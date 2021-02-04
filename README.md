# Infrastructure modules

A collection of Terraform modules to deploy various pieces of infrastructure.

# Table of Contents

- [Usage](#usage)
- [Development](#development)
- [Examples](#examples)
- [Links](#links)
- [To Do](#to-do)
- [Referenced by](#referenced-by)

## Usage

Refer to `README.md` files in each specific module directory under `modules` for instructions on how to use each module.
The easiest way to use the modules is by referencing them with Terragrunt, following the principles outlined in
[How to use the Gruntwork Infrastructure as Code Library](https://gruntwork.io/guides/foundations/how-to-use-gruntwork-infrastructure-as-code-library/),
with an example `terragrunt.hcl` file presented below:

```hcl
terraform {
  source = "git@github.com:vytautaskubilius/infrastructure-modules.git//modules/acm-certificate?ref=v0.1.0"
}

inputs = {
  aws_region                = "us-east-1"
  domain_name               = "example.com"
  subject_alternative_names = ["www", "api"]
  hosted_zone_id            = "Z3P5QSUBK4POTI"
  tags                      = {
    project = "example"
  }
}
```

When referencing the code from this repository in your own Terraform configuration, it is recommended to pin the
module to a specific release as shown (e.g. `v0.1.0`, as shown above) - this will help avoid unexpected changes to
your infrastructure resulting from updates to the code hosted here.

An example of a `live` repository that uses these modules can be found [here](https://github.com/vytautaskubilius/infrastructure-live). 

## Development

This repository is maintained for personal use, and isn't (currently) meant to be actively updated, but pull requests
and knowledge sharing is always welcome! 

[`Terratest`](https://terratest.gruntwork.io) is used for automated testing of the code, with the tests stored in the 
`test` directory, so every update to existing modules will be expected to pass the tests, and new modules will be 
expected to be committed with new tests. GitHub Actions are used for automating the tests.

[`pre-commit`](https://pre-commit.com) hooks are provided in `.pre-commit-config.yaml`, and can be installed following
`pre-commit` documentation.

## Examples

Examples of using the code can be found in the `examples` directory. These examples are also used for executing the
`Terratest` tests.

## Links

- [`pre-commit`](https://pre-commit.com)
- [`Terratest`](https://terratest.gruntwork.io)
- [How to use the Gruntwork Infrastructure as Code Library](https://gruntwork.io/guides/foundations/how-to-use-gruntwork-infrastructure-as-code-library/)

## To Do

- No specific plans at the moment.

## Referenced by

- [`infrastructure-live`](https://github.com/vytautaskubilius/infrastructure-live)