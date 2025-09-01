output "bastion_instance_id" {
  description = "ID of the bastion host instance"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_security_group_id" {
  description = "Security group ID of the bastion host"
  value       = aws_security_group.bastion.id
}

output "ssh_command" {
  description = "SSH command to connect to bastion host"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.bastion.public_ip}"
}