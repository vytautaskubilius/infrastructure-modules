data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    domain                       = var.domain
    mysql_root_password          = data.aws_ssm_parameter.mysql_root_password.value
    mysql_wordpressuser_password = data.aws_ssm_parameter.mysql_wordpressuser_password.value
  }
}

data "aws_ssm_parameter" "mysql_root_password" {
  name = "${var.domain}_mysql_root_password"
}

data "aws_ssm_parameter" "mysql_wordpressuser_password" {
  name = "${var.domain}_mysql_wordpressuser_password"
}

data "aws_iam_policy_document" "instance_profile" {
  statement {
    sid = "AllowS3ObjectReadWrite"

    actions = [
      "s3:ListBucket",
      "s3:*Object*"
    ]
    effect    = "Allow"
    resources = [
      aws_s3_bucket.backup.arn,
      "${aws_s3_bucket.backup.arn}/*"
    ]
  }
}
