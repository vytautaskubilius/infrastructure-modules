variable "hosted_zone_id" {
  description = "Hosted zone ID in which DNS records will be created"
  type        = string
}

variable "hostname" {
  description = "Root domain name for the website (e.g. example.com)"
}