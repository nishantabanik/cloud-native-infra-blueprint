# Compute VPC - for EKS and ALB
module "compute_vpc" {
  source = "../modules/vpc"
  name = "${var.environment}-compute-vpc"
  cidr = var.compute_vpc_cidr
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  
  # Public subnets for ALB and bastion
  public_subnets = [
    cidrsubnet(var.compute_vpc_cidr, 8, 1),  # 10.0.1.0/24
    cidrsubnet(var.compute_vpc_cidr, 8, 2)   # 10.0.2.0/24
  ]
  
  enable_nat_gateway = true
  
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" 
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" 
  }
  
  tags = var.tags
}

# Data VPC - for RDS database only
module "data_vpc" {
  source = "../modules/vpc"
  name = "${var.environment}-data-vpc"
  cidr = var.data_vpc_cidr
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  
  enable_nat_gateway = false
  tags = var.tags
}