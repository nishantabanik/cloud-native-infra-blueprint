###################################################
# environment specific value assignment to variables
###################################################

### Sample variables
environment = "dev"
region      = "eu-central-1"
state_bucket = "sre-falcon-tf-state"

tags = {
  "Owner"        = "SRE Team"
  "Environment"  = "development"
  "AWSRegion"    = "Frankfurt"
  "Organization" = "Raisin SE"
  "ManagedBy"   = "terraform"
}


eks_cluster_name = "sre-eks"
eks_cluster_version = "1.31"
# create_eks_cluster = false
# service_worker_node_group_instance_type = "t3.medium"

bastion_host_whitelist = ["10.10.0.0/16"]

# KMS settings
create_kms_keys = true