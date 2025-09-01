# KMS Key for S3 encryption
module "s3_kms_key" {
  source = "../modules/kms"
  
  environment = var.environment
  key_usage   = "s3"
  name_prefix = var.environment
  tags = var.tags
}

# KMS Key for RDS encryption  
module "rds_kms_key" {
  source = "../modules/kms"
  
  environment = var.environment
  key_usage   = "rds"
  name_prefix = var.environment
  tags = var.tags
}

# KMS Key for EKS secrets encryption
module "eks_kms_key" {
  source = "../modules/kms"
  
  environment = var.environment
  key_usage   = "eks-secrets"
  name_prefix = var.environment
  tags = var.tags

}

# KMS key for encrypting sensitive data
module "kms" {
  source = "../modules/kms"

  environment = var.environment
  key_usage   = "encrypted-secrets"
  name_prefix            = var.environment
  tags                   = var.tags
}