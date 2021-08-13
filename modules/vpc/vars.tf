variable "name" {
  description = "VPC name"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block to assign to the VPC"
  type        = string
}

variable "environment" {
  description = "Environment into which this module is being deployed"
  type        = string
}

variable "project" {
  description = "The project into which this module is being deployed (used for tagging resources)"
  type        = string
}

variable "tags" {
  description = "Map of additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
