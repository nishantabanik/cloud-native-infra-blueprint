variable "domain_name" {
  description = "Primary domain name for the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Method to use for domain validation"
  type        = string
  default     = "DNS"
}

variable "zone_id" {
  description = "Route53 zone ID for DNS validation"
  type        = string
}

variable "tags" {
  description = "Tags for the certificate"
  type        = map(string)
  default     = {}
}