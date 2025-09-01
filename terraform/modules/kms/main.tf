resource "aws_kms_key" "main" {
  description             = "KMS key for ${var.environment} environment"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
  
  tags = {
    Name        = "${var.environment}-kms-key"
    Environment = var.environment
    Usage       = var.key_usage
  }
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.name_prefix}-${var.key_usage}-key"
  target_key_id = aws_kms_key.main.key_id
}

resource "aws_kms_key" "eks" {
  description             = "KMS key for EKS cluster encryption"
  deletion_window_in_days = var.deletion_window_in_days
  
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-eks-key"
  })
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.name_prefix}-${var.key_usage}-eks-key"
  target_key_id = aws_kms_key.eks.key_id
}

data "aws_caller_identity" "current" {}