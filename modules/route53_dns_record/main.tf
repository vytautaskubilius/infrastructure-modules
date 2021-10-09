resource "aws_route53_record" "record" {
  for_each = var.record_map

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  records = each.value.records
  ttl     = var.ttl
}
