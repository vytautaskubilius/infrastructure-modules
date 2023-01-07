# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.1] - 2023-01-07

### Changed

- The `wordpress-instance` module now uses the `templatefile` function instead of the deprecated `template` provider.

## [0.4.0] - 2022-01-20

### Added

- The `security/iam/oidc` module for creating an IAM OpenID Connect Provider.

## [0.3.0] - 2021-10-09

### Changed

- The `route53_dns_record` module now requires the DNS record name to be provided as a value instead of it being read
  in from the map key.
  - This is to allow for the creation of multiple records of different types with the same name.

## [0.2.4] - 2021-08-30

### Changed

- The WordPress instance module no longer references hardcoded domain name parameters.

## [0.2.3] - 2021-08-26

### Changed

- The `vpc_security_group_ids` argument is used instead of `security_groups` when creating the WordPress AWS instance.
  - This is done to avoid a persistent diff that the previously used argument was causing as it is only meant to be used
  with EC2-Classic and Default VPC instances.

## [0.2.2] - 2021-08-26

### Changed

- The command for the WordPress instance backup cronjob was incorrect - this has now been fixed.

## [0.2.1] - 2021-08-25

### Changed

- VPC and Route53 Hosted Zone modules no longer accept tag variables, and don't create tags as part of deployment. 
Instead, the tags should be specified via the `default_tags` block in the `aws` provider when deploying the modules.

## [0.2.0] - 2021-08-25

### Added

- Module for creating a VPC.
- Module for creating a Route53 hosted zone.
- Module for creating Route53 DNS records.
- Module for creating an EC2 instance. The module configures the instance via a user data script as follows:
  - It uses the latest Ubuntu 20.04 AMI.
  - It installs all the WordPress dependencies.
  - It creates an S3 bucket for storing WordPress backups.
  - It configures the S3 bucket to use versioning and discard old backups after 14 days.
  - It sets up an instance profile to enable the instance to access the S3 bucket.
  - It performs the necessary steps to secure the default MySQL setup.
  - it creates the MySQL database for WordPress.
  - It installs WordPress on the instance.
  - It sets up automated backup to S3 via a cron job.

## [0.1.0] - 2021-02-04

### Added

- Module for creating auto-validating ACM certificates.
- Module for creating infrastructure for hosting a static website with CloudFront and S3.

[0.4.1]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.2.4...v0.3.0
[0.2.3]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/vytautaskubilius/infrastructure-modules/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/vytautaskubilius/infrastructure-modules/releases/tag/v0.1.0
