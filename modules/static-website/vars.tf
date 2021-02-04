variable "region" {
  description = "AWS region to deploy this into"
  type        = string
  default     = "eu-north-1"
}

variable "hostname" {
  description = "Root domain name for the website (e.g. example.com)"
  type        = string
}

variable "subdomains" {
  description = "Subdomains to add on top of the root domain (e.g. www, api)"
  type        = list(string)
  default     = ["www"]
}

variable "root_redirect_subdomain" {
  description = "Subdomain to which root domain's traffic should be redirected"
  type        = string
  default     = "www"
}

variable "hosted_zone_id" {
  description = "Hosted zone ID to use for creating DNS records"
  type        = string
}

variable "tags" {
  description = "Tags to attach to resources that get created"
  type        = map(string)
}