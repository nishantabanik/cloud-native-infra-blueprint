##################################################################################
# REMOTE TERRAFORM STATE
##################################################################################

# Remote state file
data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "sre-falcon-tf-state"
    key    = "wk-global.tfstate"
    region = "eu-central-1"
  }
}
