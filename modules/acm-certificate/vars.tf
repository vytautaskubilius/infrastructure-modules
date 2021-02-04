variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-north-1"
}

variable "domain_name" {
  description = "CN for the certificate being created"
  type        = string
}

variable "subject_alternative_names" {
  description = "SANs for the certificate being created"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "List of tags to be attached to the certificate"
  type        = map(string)
}

variable "hosted_zone_id" {
  description = "Hosted zone ID where the validation records should be deployed"
  type        = string
}