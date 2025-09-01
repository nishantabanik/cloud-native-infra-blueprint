# S3 Bucket for sensitive data storage
module "s3_bucket" {
  source = "../modules/s3"

  environment = var.environment
  bucket_name = "${var.environment}-${var.project_name}-sensitive-data"
  kms_key_id  = module.kms.key_id
  
  tags = var.tags
}

# Access logs bucket  
module "s3_access_logs" {
  source = "../modules/s3"

  environment = var.environment
  bucket_name = "${var.environment}-${var.project_name}-access-logs"
  kms_key_id  = module.kms.key_id
  
  tags = var.tags
}