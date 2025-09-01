variable "cluster_identifier" {
  description = "RDS Cluster name"
  type        = string
}

variable "engine" {
  default     = "aurora-mysql"
  description = "RDS engine"
}

variable "engine_version" {
  default     = "8.0.mysql_aurora.3.02.0"
  description = "Engine version"
}

variable "instance_class" {
  default     = "db.t3.medium"
  description = "Instance type"
}

variable "instance_count" {
  default     = 2
  description = "Number of nodes"
}

variable "database_name" {
  type        = string
  description = "Database name"
}

variable "master_username" {
  type        = string
  description = "RDS username"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets in the Data VPC"
}

variable "vpc_id" {
  type        = string
  description = "Data VPC ID"
}

variable "kms_key_id" {
  type        = string
  description = "KMS for encryption"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
}

variable "backup_retention_period" {
  default     = 7
  description = "Days to keep backup"
}

variable "preferred_backup_window" {
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  default     = "sun:04:00-sun:05:00"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
