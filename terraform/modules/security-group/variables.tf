variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description for the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where SG will be created"
  type        = string
}

variable "eks_control_plane_cidr_blocks" {
  description = "CIDR blocks of EKS control plane for node access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
