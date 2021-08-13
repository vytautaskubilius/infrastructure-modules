# Route53 Hosted Zone

This simple module creates a hosted zone tagged with a common set of variables.

# Usage

```hcl
terraform {
  source = "git@github.com:vytautaskubilius/infrastructure-modules.git//modules/route53_hosted_zone"
}

inputs = {
  name        = "kumetynas.lt"
  environment = "production"
  project     = "kumetynas"
}
```
