resource "aws_cloudwatch_log_group" "waf_log_group" {
  name              = "/aws/wafv2/${var.name}"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_wafv2_web_acl" "main" {
  name  = var.name
  scope = var.scope

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                 = "CommonRuleSetMetric"
      sampled_requests_enabled    = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                 = "KnownBadInputsRuleSetMetric"
      sampled_requests_enabled    = true
    }
  }

  tags = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                 = var.name
    sampled_requests_enabled    = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count = var.enable_logging ? 1 : 0
  
  resource_arn            = aws_wafv2_web_acl.main.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group.arn]

  depends_on = [aws_cloudwatch_log_group.waf_log_group]
}