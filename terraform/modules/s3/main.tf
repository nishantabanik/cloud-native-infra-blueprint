resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  
  tags = merge(var.tags, {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "sensitive-data-storage"
  })
}
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id
  
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id
  
  rule {
    id     = "lifecycle_rule"
    status = "Enabled"
    
    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket" "logging" {
  bucket = "${var.bucket_name}-access-logs"
  
  tags = merge(var.tags, {
    Name        = "${var.bucket_name}-access-logs"
    Environment = var.environment
    Purpose     = "access-logs"
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id
  
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "main" {
  bucket = aws_s3_bucket.main.id
  
  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "access-logs/"
}

resource "aws_s3_bucket_notification" "main" {
  count  = var.lambda_function_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.main.id
  
  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }
  
  depends_on = [var.lambda_permission_dependency]
}