terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "root_redirect" {
  bucket        = var.hostname
  acl           = "public-read"
  force_destroy = true

  website {
    redirect_all_requests_to = "https://${var.root_redirect_subdomain}.${var.hostname}"
  }

  tags = var.tags
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = var.hostname
}

resource "aws_s3_bucket" "subdomains" {
  count = length(var.subdomains)

  bucket        = "${var.subdomains[count.index]}.${var.hostname}"
  acl           = "private"
  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_policy" "subdomain_bucket_policy" {
  count = length(aws_s3_bucket.subdomains)

  bucket = aws_s3_bucket.subdomains[count.index].id
  policy = data.aws_iam_policy_document.bucket_policy[count.index].json
}

module "acm_certificate" {
  source = "../acm-certificate"

  region                    = "us-east-1" # Certs need to be in us-east-1 to be usable by Cloudfront
  domain_name               = var.hostname
  subject_alternative_names = [for subdomain in var.subdomains : "${subdomain}.${var.hostname}"]
  hosted_zone_id            = var.hosted_zone_id
  tags                      = var.tags
}

resource "aws_cloudfront_distribution" "root" {
  enabled = true
  aliases = [var.hostname]
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.hostname}-S3"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.root_redirect.website_endpoint
    origin_id   = "${var.hostname}-S3"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = module.acm_certificate.cert_arn
    ssl_support_method  = "sni-only"
  }
  price_class = "PriceClass_100"
  comment     = "${var.hostname} - root redirect"

  tags = var.tags
}

resource "aws_cloudfront_distribution" "subdomains" {
  count = length(var.subdomains)

  enabled = true
  aliases = ["${var.subdomains[count.index]}.${var.hostname}"]
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.subdomains[count.index]}.${var.hostname}-S3"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.subdomains[count.index].bucket_regional_domain_name
    origin_id   = "${var.subdomains[count.index]}.${var.hostname}-S3"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = module.acm_certificate.cert_arn
    ssl_support_method  = "sni-only"
  }
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  comment             = "${var.subdomains[count.index]}.${var.hostname}"

  tags = var.tags
}

resource "aws_route53_record" "root" {
  name = var.hostname
  type = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.root.domain_name
    zone_id                = aws_cloudfront_distribution.root.hosted_zone_id
  }
  zone_id = var.hosted_zone_id
}

resource "aws_route53_record" "subdomains" {
  count = length(var.subdomains)

  name = "${var.subdomains[count.index]}.${var.hostname}"
  type = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.subdomains[count.index].domain_name
    zone_id                = aws_cloudfront_distribution.subdomains[count.index].hosted_zone_id
  }
  zone_id = var.hosted_zone_id
}

