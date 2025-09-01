# Base and sample variables

variable "region" {
  description = "The AWS region where all terraform operations are carried out."
  type        = string
  default     = "eu-central-1"
}

variable "state_bucket" {
  description = "The S3 bucket where the state files are stored"
  type        = string
}

variable "global_state_key" {
  description = "The terraform global state file name/object key in the S3 state bucket"
  type        = string
  default     = "global.tfstate"
}


variable "environment" {
  description = "Env of the current account (e.g. Staging, Production)"
  type        = string
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
}

variable "create_eks_cluster" {
  description = "Flag to enable / disable the cluster creation"
  type        = bool
  default     = false
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "sre-eks"
}

variable "eks_cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.31"
}

variable "bastion_host_whitelist" {
  type        = list(string)
  description = "List of IPs allowed to access bastion host"
}

variable "create_kms_keys" {
  description = "Flag to enable/disable KMS key creation"
  type        = bool
  default     = true
}

variable "compute_vpc_cidr" {
  description = "CIDR block for compute VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "data_vpc_cidr" {
  description = "CIDR block for data VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "sre-challenge"
}

variable "ssh_key_pair_name" {
  description = "SSH key for EKS nodes"
  type        = string
  default     = "default-key"
}

variable "eks_ami_id" {
  description = "AMI ID for EKS nodes (use valid eks-optimized)"
  type        = string
  default     = "ami-0ef055789c29fddcd"
}

