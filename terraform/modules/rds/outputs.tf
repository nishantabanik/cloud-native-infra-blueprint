output "cluster_id" {
  value       = aws_rds_cluster.aurora_cluster.id
  description = "RDS Cluster ID"
}

output "endpoint" {
  value       = aws_rds_cluster.aurora_cluster.endpoint
  description = "Writer endpoint"
}

output "reader_endpoint" {
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "port" {
  value       = aws_rds_cluster.aurora_cluster.port
}

output "secret_arn" {
  value       = aws_secretsmanager_secret.rds_secret.arn
}

output "security_group_id" {
  value       = aws_security_group.rds_sg.id
}
