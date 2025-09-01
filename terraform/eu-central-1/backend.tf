
##################################################################################
# REMOTE TERRAFORM STATE
##################################################################################

# Remote state file
terraform {
  backend "s3" {
    bucket         = "sre-falcon-tf-state"
    key            = "wk-sre-challenge.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
