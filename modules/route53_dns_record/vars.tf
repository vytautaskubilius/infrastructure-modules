variable "record_map" {
  description = "Map of DNS records to be created. Map is expected to use the DNS record name as key, and type and record value list as map values"
  type        = any
}

variable "hosted_zone_id" {
  description = "Hosted zone ID where the records will be created."
  type        = string
}

variable "ttl" {
  description = "Time to Live value to set on the DNS record(s)"
  type        = number
  default     = 300
}
