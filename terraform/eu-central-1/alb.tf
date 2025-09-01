# Application Load Balancer for EKS cluster
module "application_load_balancer" {
  source = "../modules/alb"

  # ALB Configuration
  name               = "${var.environment}-eks-alb"
  internal           = false
  load_balancer_type = "application"
  subnets           = module.compute_vpc.public_subnets
  security_groups   = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false


  # Target Group Configuration
  target_group_name     = "${var.environment}-eks-tg"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  target_group_vpc_id   = module.compute_vpc.vpc_id
  target_group_target_type = "ip"

  # Health Check Configuration
  health_check_enabled             = true
  health_check_healthy_threshold   = 2
  health_check_interval            = 30
  health_check_matcher             = "200"
  health_check_path                = "/"
  health_check_port                = "traffic-port"
  health_check_protocol            = "HTTP"
  health_check_timeout             = 5
  health_check_unhealthy_threshold = 2

  # Listener Configuration
  listener_port           = "443"
  listener_protocol       = "HTTPS"
  listener_ssl_policy     = "ELBSecurityPolicy-TLS-1-2-2017-01"
  listener_certificate_arn = module.acm_certificate.certificate_arn

  # HTTP to HTTPS Redirect
  enable_http_listener = true
  http_listener_port   = "80"

  tags = var.tags

  depends_on = [module.acm_certificate]
}

# WAF Association
resource "aws_wafv2_web_acl_association" "alb_waf" {
  resource_arn = module.application_load_balancer.alb_arn
  web_acl_arn  = module.waf.web_acl_arn

  depends_on = [
    module.application_load_balancer,
    module.waf
  ]
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.compute_vpc.vpc_id

  # HTTPS from whitelisted IPs only
  ingress {
    description = "HTTPS from whitelisted IPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.bastion_host_whitelist
  }

  # HTTP redirect to HTTPS
  ingress {
    description = "HTTP redirect to HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.bastion_host_whitelist
  }

  # Outbound to EKS nodes
  egress {
    description = "To EKS nodes"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [module.compute_vpc.vpc_cidr_block]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-alb-sg"
  })
}