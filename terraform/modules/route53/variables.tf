variable "zone_id" {
  description = "Route53 hosted zone ID where the record will be created"
  type        = string
  validation {
    condition     = can(regex("^Z[0-9A-Z]+$", var.zone_id))
    error_message = "Zone ID must be a valid Route53 zone ID starting with 'Z'."
  }
}

variable "record_name" {
  description = "DNS record name (FQDN)"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\\.([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?))*$", var.record_name))
    error_message = "Record name must be a valid domain name."
  }
}

variable "record_type" {
  description = "DNS record type"
  type        = string
  default     = "A"
  validation {
    condition     = contains(["A", "AAAA", "CNAME"], var.record_type)
    error_message = "Record type must be A, AAAA, or CNAME for alias records."
  }
}

variable "alias_name" {
  description = "DNS name of the resource record set to which you want to route traffic"
  type        = string
}

variable "alias_zone_id" {
  description = "Hosted zone ID of the resource record set to which you want to route traffic"
  type        = string
  validation {
    condition     = can(regex("^Z[0-9A-Z]+$", var.alias_zone_id))
    error_message = "Alias zone ID must be a valid Route53 zone ID starting with 'Z'."
  }
}

variable "evaluate_target_health" {
  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}