variable "name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Type of load balancer"
  type        = string
  default     = "application"
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "allowed_ips" {
  description = "List of allowed IP CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port of the target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol of the target group"
  type        = string
  default     = "HTTP"
}

variable "target_group_vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "target_group_target_type" {
  description = "Target type for the target group"
  type        = string
  default     = "ip"
}

variable "health_check_enabled" {
  description = "Enable health checks"
  type        = bool
  default     = true
}

variable "health_check_healthy_threshold" {
  description = "Healthy threshold for health checks"
  type        = number
  default     = 2
}

variable "health_check_interval" {
  description = "Interval for health checks"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "Matcher for health checks"
  type        = string
  default     = "200"
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port for health checks"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "Protocol for health checks"
  type        = string
  default     = "HTTP"
}

variable "health_check_timeout" {
  description = "Timeout for health checks"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "Unhealthy threshold for health checks"
  type        = number
  default     = 2
}

variable "listener_port" {
  description = "Port for the HTTPS listener"
  type        = string
  default     = "443"
}

variable "listener_protocol" {
  description = "Protocol for the listener"
  type        = string
  default     = "HTTPS"
}

variable "listener_ssl_policy" {
  description = "SSL policy for the listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "listener_certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}

variable "enable_http_listener" {
  description = "Enable HTTP listener for redirect"
  type        = bool
  default     = true
}

variable "http_listener_port" {
  description = "Port for the HTTP listener"
  type        = string
  default     = "80"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}