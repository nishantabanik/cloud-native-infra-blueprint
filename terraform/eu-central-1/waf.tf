# WAF with minimal managed rules
module "waf" {
  source = "../modules/waf"

  # WAF Configuration - Use var.environment here
  name  = "${var.environment}-web-acl"
  scope = "REGIONAL"
  allowed_ips = var.bastion_host_whitelist
  environment = var.environment
  enable_logging = false

  tags = var.tags
}