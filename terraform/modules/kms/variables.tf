variable "deletion_window_in_days" {
  description = "Number of days before the KMS key is deleted"
  type        = number
  default     = 7
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "key_usage" {
  description = "Usage description for the KMS key"
  type        = string
  default     = "general"
}

variable "name_prefix" {
  description = "Prefix for naming KMS resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to KMS resources"
  type        = map(string)
  default     = {}
}