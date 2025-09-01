
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_deployment.zip"
  
  source {
    content  = file("${path.module}/src/lambda_function.py")
    filename = "lambda_function.py"
  }
  
  source {
    content  = file("${path.module}/src/requirements.txt")
    filename = "requirements.txt"
  }
}

resource "aws_iam_role" "lambda_execution" {
  name_prefix = "${var.function_name}-execution-"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  name_prefix = "${var.function_name}-policy-"
  role        = aws_iam_role.lambda_execution.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream", 
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ]
        Resource = "arn:aws:secretsmanager:*:*:secret:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ]
        Resource = var.kms_key_id
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_security_group" "lambda_sg" {
  name_prefix = "${var.function_name}-lambda-"
  vpc_id      = var.vpc_id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic for Lambda execution"
  }
  
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
    description = "MySQL access to data VPC"
  }
  
  tags = merge(var.tags, {
    Name = "${var.function_name}-lambda-sg"
  })
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 30
  kms_key_id        = var.kms_key_id
  
  tags = var.tags
}

resource "aws_lambda_function" "csv_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role            = aws_iam_role.lambda_execution.arn
  handler         = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 512
  
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
  
  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
      RDS_ENDPOINT   = var.rds_endpoint
      DATABASE_NAME  = var.database_name
      KMS_KEY_ID     = var.kms_key_id
    }
  }
  
  kms_key_arn = var.kms_key_id
  
  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
    aws_iam_role_policy_attachment.lambda_vpc_execution
  ]
  
  tags = var.tags
}

resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowS3BucketInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "${var.function_name}-schedule"
  description         = "Scheduled execution for CSV processing"
  schedule_expression = "rate(5 minutes)"
  
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "CSVProcessorTarget"
  arn       = aws_lambda_function.csv_processor.arn
}

resource "aws_lambda_permission" "eventbridge_invoke" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_processor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}