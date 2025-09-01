variable "peering_name" {
  description = "Name of the VPC peering connection (used in tags)"
  type        = string
}

variable "environment_tag" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "requester_vpc_id" {
  description = "VPC ID of the requester (compute VPC)"
  type        = string
}

variable "accepter_vpc_id" {
  description = "VPC ID of the accepter (data VPC)"
  type        = string
}

variable "accepter_account_id" {
  description = "Account ID of accepter VPC owner (use data.aws_caller_identity.account_id if same)"
  type        = string
}

variable "accepter_region_id" {
  description = "Region of the accepter VPC"
  type        = string
}

variable "requester_vpc_rt_id" {
  description = "List with one element: route table ID of the requester VPC"
  type        = list(string)
}

variable "accepter_vpc_private_rt_ids" {
  description = "List of route table IDs for the accepter VPC private subnets"
  type        = list(string)
}

variable "requester_cidr" {
  description = "CIDR block of requester VPC"
  type        = string
}

variable "accepter_cidr" {
  description = "CIDR block of accepter VPC"
  type        = string
}

variable "accepter_private_rt_count" {
  description = "Number of route tables in accepter VPC private subnets"
  type        = number
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "enabled" {
  description = "Enable or disable this module"
  type        = bool
  default     = true
}
