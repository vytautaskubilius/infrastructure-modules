resource "aws_instance" "wordpress" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  key_name             = var.key_pair_name
  subnet_id            = var.subnet_id
  user_data            = data.template_file.user_data.rendered
  iam_instance_profile = aws_iam_instance_profile.wordpress.name
  security_groups      = [aws_security_group.wordpress.id]
}

resource "aws_security_group" "wordpress" {
  name        = "${var.domain} inbound allow"
  description = "Traffic allowed to reach the instance that serves ${var.domain}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "http" {
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress.id
  type              = "ingress"
}

resource "aws_security_group_rule" "https" {
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress.id
  type              = "ingress"
}

resource "aws_security_group_rule" "ssh" {
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress.id
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress.id
  type              = "egress"
}

resource "aws_iam_role" "wordpress" {
  name               = "wordpress-instance-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "wordpress" {
  name = "wordpress"
  role = aws_iam_role.wordpress.name
}

resource "aws_iam_role_policy" "wordpress" {
  policy = data.aws_iam_policy_document.instance_profile.json
  role   = aws_iam_role.wordpress.id
}

resource "aws_s3_bucket" "backup" {
  bucket = "${var.domain}-backup"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule {
    enabled = true

    expiration {
      days = 14
    }
  }
}

resource "aws_route53_record" "root" {
  name    = var.domain
  type    = "A"
  zone_id = var.hosted_zone_id
  records = [aws_instance.wordpress.public_ip]
  ttl     = 300
}

resource "aws_route53_record" "www" {
  name    = "www.${var.domain}"
  type    = "A"
  zone_id = var.hosted_zone_id
  records = [aws_instance.wordpress.public_ip]
  ttl     = 300
}

