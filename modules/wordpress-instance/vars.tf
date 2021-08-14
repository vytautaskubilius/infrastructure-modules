variable "instance_type" {
  description = "Instance type to use with the deployment"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID into which to deploy the instance"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the key pair to use with the instance"
  type        = string
}

variable "domain" {
  description = "Domain name for the website"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID into which to deploy the DNS records for the website"
  type        = string
}

variable "vpc_id" {
  description = "VPC into which the resources will be deployed"
  type        = string
}
