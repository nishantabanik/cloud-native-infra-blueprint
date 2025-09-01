module "rds_aurora" {
  source = "../modules/rds"

  # Basic configuration
  cluster_identifier = "${var.environment}-rds-aurora"
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.08.2"
  database_name      = "mydb"
  master_username    = "admin"
  
  # Network configuration - Data VPC private subnets only
  vpc_id     = module.data_vpc.vpc_id
  subnet_ids = module.data_vpc.private_subnets
  
  # Security - Only allow access from compute VPC
  allowed_cidr_blocks = [module.compute_vpc.vpc_cidr_block]
  
  # Encryption using KMS
  kms_key_id = module.rds_kms_key.key_arn
  # allowed_security_groups = [module.eks.cluster_sg_id]
  tags                    = var.tags
}
