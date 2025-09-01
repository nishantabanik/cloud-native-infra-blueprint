### Sample variable definitions

variable "region" {
  description = "aws geographic region"
  default     = "eu-central-1"
  type        = string
}

variable "environment" {
  description = "aws environment (test,stage,prod etc)"
  type        = string
}

variable "state_bucket" {
  description = "terraform state bucket"
  type        = string
}

