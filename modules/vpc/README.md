# VPC

This module creates a simple VPC with a public subnet and an internet gateway. In its current state it's an MVP that
allows me to easily host a single-instance web server.

# Usage

```hcl
terraform {
  source = "git@github.com:vytautaskubilius/infrastructure-modules.git//modules/vpc"
}

inputs = {
  name        = "kumetynas"
  environment = "production"
  project     = "kumetynas"
  cidr_block  = "10.42.0.0/22"
}
```

# TODO

- Private and persistence subnets
- NACLs
- NAT gateway options
