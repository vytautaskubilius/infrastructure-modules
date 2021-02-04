# Automatically validated ACM certificate

This module deploys an automatically validated ACM certificate for provided domains.

# Table of Contents

- [Usage](#usage)
- [To Do](#to-do)

## Usage

The module can be invoked from any other Terraform code using the Terraform module `source` option:

```hcl
module "acm_certificate" {
  source = "git@github.com:vytautaskubilius/infrastructure-modules.git//modules/acm-certificate?ref=v0.1.0"

  region                    = "us-east-1"
  domain_name               = "example.com"
  subject_alternative_names = ["www.example.com", "api.example.com"]
  hosted_zone_id            = "hosted_zone_id"
  
  tags                      = {
    project = "test"
  }
}
```

The module deploys the following resources:
- ACM certificate with the provided CN and SANs.
- Route53 validation records in the selected hosted zone.
    - **NOTE**: The domain of the hosted zone has to match the root of the hostname for which the certificate is being
      generated.

## To Do

- No specific plans at this time.
