module "eks_cluster" {
  source = "../modules/eks"

  # Core config
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_version  = var.eks_cluster_version
  eks_role_arn         = module.eks_cluster_iam.iam_role_arn
  eks_subnet_ids       = module.compute_vpc.private_subnets
  eks_security_group_ids = []
  eks_vpc_id = module.compute_vpc.vpc_id
  eks_worker_vpc_cidr = [module.compute_vpc.vpc_cidr_block]
  tags = var.tags

  eks_endpoint_private_access = true
  eks_endpoint_public_access  = true
  eks_public_access_cidrs     = ["0.0.0.0/0"]

  # Logs, Tags, Networking
  eks_enabled_log_types = ["api", "audit", "authenticator"]
  eks_tags              = var.tags
  eks_network_config    = "172.20.0.0/16"

  # kms for encryption
  kms_key_arn = module.kms.eks_key_arn
}

module "eks_node_groups" {
  source = "../modules/eks/node-groups"

  eks_node_group_eks_cluster_name = var.eks_cluster_name
  eks_node_group_name             = "default-node-group"
  eks_node_role_arn               = module.eks_node_iam.iam_role_arn
  eks_node_group_subnet_ids       = module.compute_vpc.private_subnets
  eks_node_group_desired_size     = 1
  eks_node_group_min_size         = 1
  eks_node_group_max_size         = 2
  eks_node_group_capacity_type    = "ON_DEMAND"
  eks_node_group_instance_type    = "t3.medium"
  eks_node_group_disk_size        = 20
  eks_node_group_ssh_key          = null
  eks_node_group_security_group_ids = []
  eks_node_group_launch_template_name = "eks-node-template-${var.environment}"
  eks_node_group_ami_id              = data.aws_ami.eks_worker.id
  eks_node_group_tags                = var.tags
  eks_node_group_labels              = {
    env = var.environment
  }

  eks_node_group_auth_base64        = module.eks_cluster.cluster_ca
  eks_node_group_eks_endpoint       = module.eks_cluster.cluster_endpoint
  eks_cluster_name                  = var.eks_cluster_name
  eks_region                        = var.region
  
  depends_on = [
    module.eks_cluster,
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_cluster_version}-v*"]
  }
  
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# EKS Cluster IAM Role
module "eks_cluster_iam" {
  source = "../modules/iam"
  
  role_name = "${var.eks_cluster_name}-cluster"
  tags = var.tags
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# EKS Node IAM Role
module "eks_node_iam" {
  source = "../modules/iam"

  role_name = "${var.eks_cluster_name}-node"
  tags = var.tags
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = module.eks_cluster_iam.iam_role_name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = module.eks_node_iam.iam_role_name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = module.eks_node_iam.iam_role_name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = module.eks_node_iam.iam_role_name
}

