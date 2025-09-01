# Bastion Host - Small EC2 in compute public subnet
module "bastion_host" {
  source = "../modules/bastion"

  # Instance Configuration
  
  name = "${var.environment}-bastion"
  instance_type = "t3.micro" 
  
  # Network Configuration - Using compute VPC public subnet
  vpc_id    = module.compute_vpc.vpc_id
  subnet_id = module.compute_vpc.public_subnets[0]
  
  # Security Configuration - SSH only from whitelisted IPs
  key_name           = var.ssh_key_pair_name
  allowed_ips = var.bastion_host_whitelist  # From terraform.tfvars
  
  # Session Manager for secure access
  enable_session_manager = true
  
  tags = merge(var.tags, {
    Name    = "${var.environment}-bastion-host"
    Purpose = "secure-access"
    Type    = "bastion"
  })

  depends_on = [module.compute_vpc]
}

