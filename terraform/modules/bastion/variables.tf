variable "name" {
  description = "Name of the bastion host instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "VPC ID where bastion host will be created"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}

variable "allowed_ips" {
  description = "List of CIDR blocks allowed to SSH to bastion host"
  type        = list(string)
}

variable "enable_session_manager" {
  description = "Enable AWS Session Manager for secure access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}