variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
}

variable "allowed_principals" {
  description = "List of allowed principals"
  type        = list(string)
  default     = []
}

variable "lambda_function_arn" {
  description = "Lambda function ARN for S3 notifications"
  type        = string
  default     = ""
}

variable "lambda_permission_dependency" {
  description = "Dependency for Lambda permission"
  type        = any
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}