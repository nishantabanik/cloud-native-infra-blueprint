
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "azs" {
  description = "A list of Availability zones in the region"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable/Disable IPV6 support"
  type        = bool
  default     = false
}

variable "assign_ipv6_address_on_creation" {
  description = "Enable/Disable auto assigning IPV6 addresses to instances on subnets with IPV6 enabled"
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "private_propagating_vgws" {
  description = "A list of VGWs the private route table should propagate."
  type        = list(string)
  default     = []
}

variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  type        = bool
  default     = true
}


variable "private_subnet_newbits" {
  description = ""
  type        = number
  default     = 4
}

variable "public_subnet_newbits" {
  description = ""
  type        = number
  default     = 8
}

