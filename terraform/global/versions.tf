terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.90"
    }
  }
  required_version = ">= 1.9.8, < 1.12.0"
}
