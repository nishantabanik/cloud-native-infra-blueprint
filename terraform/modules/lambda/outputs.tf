output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.csv_processor.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.csv_processor.arn
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.csv_processor.invoke_arn
}

output "role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution.arn
}

output "lambda_permission" {
  description = "Lambda permission for S3 notifications"
  value       = aws_lambda_permission.s3_invoke
}