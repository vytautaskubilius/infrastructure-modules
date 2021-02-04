# Static website infrastructure in AWS

This module deploys infrastructure for a static website in AWS with CloudFront and S3.

# Table of Contents

- [Usage](#usage)
- [To Do](#to-do)

## Usage

The module can be invoked from any other Terraform code using the Terraform module `source` option:

```hcl
module "static_website" {
  source = "git@github.com:vytautaskubilius/infrastructure-modules.git//modules/static-website?ref=v0.1.0"

  hosted_zone_id = "hosted_zone_id"
  hostname       = "example.com"
  subdomains     = ["www", "api"]
  tags = {
    project = "test"
  }
}
```

The module deploys the following resources:
- A public S3 bucket for the root domain that is used solely for redirecting traffic to one of the subdomains (`www`
  by default).
- Private S3 buckets for each subdomain (with only a `www` subdomain being deployed by default).
- CloudFront distributions for root domain and subdomains.
- ACM certificate that covers the root domain and the subdomains.
- Route53 DNS records in a specified hosted zone that alias to the CloudFront distributions. 
  - **NOTE**: The domain of the hosted zone has to match the root of the hostname that is being deployed.
- S3 bucket access policies to allow access via CloudFront only.  

## To Do

- No specific plans at this time.
