# Route53 DNS record

This simple module takes a map of DNS records and creates them in AWS Route53.

# Usage

```hcl
terraform {
  source = "git@github.com:vytautaskubilius/infrastructure-modules.git//modules/route53_dns_record"
}

dependency "hosted_zone" {
  config_path = "${get_terragrunt_dir()}/../hosted_zone"
}

inputs = {
  hosted_zone_id = dependency.hosted_zone.outputs.hosted_zone_id
  record_map = {
    "www.example.cpm" = {
      type = "CNAME"
      records = ["example.com"]
    },
    "api.kumetynas.lt" = {
      type = "A"
      records = ["1.2.3.4"]
    }
  }
}
```
