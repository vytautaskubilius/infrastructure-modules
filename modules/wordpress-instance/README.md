# Instance with WordPress deployed

This module deploys an AWS instance with WordPress installed on it. It also creates Route53 DNS records for the website,
and an S3 bucket for hosting DB backups with an IAM instance profile that allows the instance to upload the DB dumps.

The module doesn't deploy a key pair for connecting to the instance - that needs to be done manually (the key pair name
is supplied as an input variable). DB passwords are expected to be stored in AWS SSM Parameter Store with names
that follow this convention:

```hcl
data "aws_ssm_parameter" "mysql_root_password" {
  name = "${var.domain}_mysql_root_password"
}

data "aws_ssm_parameter" "mysql_wordpressuser_password" {
  name = "${var.domain}_mysql_wordpressuser_password"
}
```

# Usage 

This module expects the VPC and the Route53 hosted zone to have been deployed beforehand as it requires the VPC ID,
subnet ID, and hosted zone ID to be supplied as input variables.

```hcl
dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../network/vpc"
}

dependency "hosted_zone" {
  config_path = "${get_terragrunt_dir()}/../../network/route53/hosted_zone"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_id = dependency.vpc.outputs.public_subnet_id
  hosted_zone_id = dependency.hosted_zone.outputs.hosted_zone_id
  key_pair_name = "kumetynas-production"
  domain = "kumetynas.lt"
}

```

# TODO

- DB backup script.
