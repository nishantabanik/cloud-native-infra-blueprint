output "key_id" {
  description = "KMS key ID"
  value       = aws_kms_key.main.key_id
}

output "key_arn" {
  description = "KMS key ARN"
  value       = aws_kms_key.main.arn
}

output "alias_name" {
  description = "KMS key alias name"
  value       = aws_kms_alias.main.name
}

output "main_key_arn" {
  description = "The Amazon Resource Name (ARN) of the main KMS key"
  value       = aws_kms_key.main.arn
}

output "eks_key_arn" {
  description = "The Amazon Resource Name (ARN) of the EKS KMS key"
  value       = aws_kms_key.eks.arn
}