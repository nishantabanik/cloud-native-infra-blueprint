variable "environment" {
  description = "Environment name"
  type        = string
}

variable "allowed_ips" {
  description = "List of allowed IP addresses"
  type        = list(string)
}

variable "rate_limit" {
  description = "Rate limit per 5 minutes"
  type        = number
  default     = 2000
}

variable "name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "scope" {
  description = "Scope of the WAF Web ACL (REGIONAL or CLOUDFRONT)"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "Scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "enable_logging" {
  description = "Enable WAF logging to CloudWatch"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the WAF resources"
  type        = map(string)
  default     = {}
}