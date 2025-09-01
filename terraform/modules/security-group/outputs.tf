output "security_group_id" {
  value       = aws_security_group.eks_node_sg.id
  description = "ID of the created security group"
}
