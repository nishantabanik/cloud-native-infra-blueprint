# ACM Certificate for HTTPS
module "acm_certificate" {
  source = "../modules/acm"

  # Domain Configuration
  domain_name = "sre-challenge-falcon.network"
  subject_alternative_names = [
    "*.sre-challenge-falcon.network"
  ]

  # Validation Configuration
  validation_method = "DNS"
  
  # Route53 Zone for DNS validation
  zone_id = data.aws_route53_zone.main.zone_id

  tags = var.tags
}

# Data source for existing Route53 zone
data "aws_route53_zone" "main" {
  name         = "sre-challenge-falcon.network"
  private_zone = false
}