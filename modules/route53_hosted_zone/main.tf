resource "aws_route53_zone" "zone" {
  name = var.name
  tags = local.common_tags
}
