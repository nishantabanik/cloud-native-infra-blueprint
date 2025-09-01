resource "aws_eks_cluster" "raisin_eks_cluster" {
  name                      = var.eks_cluster_name
  role_arn                  = var.eks_role_arn
  enabled_cluster_log_types = var.eks_enabled_log_types
  version                   = var.eks_cluster_version
  tags                      = var.eks_tags
  
  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }
  
  kubernetes_network_config {
    service_ipv4_cidr = var.eks_network_config
  }
  vpc_config {
    subnet_ids              = var.eks_subnet_ids
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.eks_public_access_cidrs
    security_group_ids      = var.eks_security_group_ids
  }
}