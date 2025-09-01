
# Create DNS record for application access
module "app_dns_record" {
  source = "../modules/route53"

  zone_id = data.aws_route53_zone.main.zone_id
  record_name = "app.sre-challenge-falcon.network"
  record_type = "A"
  alias_name    = module.application_load_balancer.alb_dns_name
  alias_zone_id = module.application_load_balancer.alb_zone_id
  evaluate_target_health = true

  tags = merge(var.tags, {
    Name        = "app-dns-record"
    Purpose     = "ALB-DNS-Alias"
    Environment = var.environment
  })

  depends_on = [module.application_load_balancer]
}