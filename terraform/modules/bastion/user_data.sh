#!/bin/bash
# Basic setup for bastion host

# Update system
yum update -y

# Install Session Manager agent (usually pre-installed on Amazon Linux 2)
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install useful tools
yum install -y htop curl wget git

# Create a welcome message
cat > /etc/motd << EOF
===========================================
    SRE Challenge Bastion Host
===========================================
This is a secure bastion host for accessing
private resources in the VPC.

Use Session Manager for secure access:
aws ssm start-session --target INSTANCE_ID

===========================================
EOF