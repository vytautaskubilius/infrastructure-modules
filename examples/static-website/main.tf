terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

module "static_website" {
  source = "../../modules/static-website"

  hosted_zone_id = var.hosted_zone_id
  hostname       = var.hostname
  subdomains     = ["www", "api"]
  tags = {
    project = "test"
  }
}

resource "aws_s3_bucket_object" "index" {
  count = length(module.static_website.s3_bucket_names)

  bucket       = module.static_website.s3_bucket_names[count.index]
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}