output "dns_records" {
  value = aws_route53_record.subdomains.*.name
}

output "s3_bucket_arns" {
  value = aws_s3_bucket.subdomains.*.arn
}

output "s3_bucket_names" {
  value = aws_s3_bucket.subdomains.*.id
}