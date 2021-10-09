# Route53 DNS record

This simple module takes a map of DNS records and creates them in AWS Route53. The keys in the `record_map` must be
unique.

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
    "www.dontpanic.lt" = {
      name = "www.dontpanic.lt"
      type = "CNAME"
      records = ["example.com"]
    },
    "api.dontpanic.lt" = {
      name = "api.dontpanic.lt"
      type = "A"
      records = ["1.2.3.4"]
    },
    "dontpanic.lt-mx" = {
      name = "dontpanic.lt"
      type = "MX"
      records = [
        "10 mx1.example.com",
        "20 mx2.example.com"
      ]
    },
    "dontpanic.lt-txt" = {
      name = "dontpanic.lt"
      type = "TXT"
      records = [
        "example"
      ]
    }
  }
}
```
