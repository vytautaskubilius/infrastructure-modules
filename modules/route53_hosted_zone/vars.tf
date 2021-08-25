variable "name" {
  description = "Hosted zone name"
}

variable "environment" {
  description = "Environment into which this module is being deployed"
  type        = string
}

variable "project" {
  description = "The project into which this module is being deployed (used for tagging resources)"
  type        = string
}
