module "vpc_peering" {
  source = "../modules/vpc-peering"

  # Provider configuration required by module
  providers = {
    aws.default = aws
  }

  peering_name     = "${var.environment}-vpc-peering"
  environment_tag  = var.environment

  requester_vpc_id = module.compute_vpc.vpc_id
  accepter_vpc_id  = module.data_vpc.vpc_id

  requester_vpc_rt_id         = [module.compute_vpc.private_route_table_ids[0]]
  accepter_vpc_private_rt_ids = module.data_vpc.private_route_table_ids
  accepter_private_rt_count   = length(module.data_vpc.private_route_table_ids)

  requester_cidr = module.compute_vpc.vpc_cidr_block
  accepter_cidr  = module.data_vpc.vpc_cidr_block

  accepter_account_id = data.aws_caller_identity.current.account_id
  accepter_region_id  = ""

  tags    = var.tags
  enabled = true
}

