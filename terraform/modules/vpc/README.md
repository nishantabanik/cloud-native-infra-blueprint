
# What is this ?
This module creates a VPC in the AWS region specifed. It creates the following components:
* 1 VPC with the CIDR block specified
* 3 Private Subnets 
* 3 Public Subnets
* 3 NAT Gateways for the private subnets 
* 1 NAT Gateway
* 1 Main route table for the VPC
* 1 Route table for the public subnets
* 3 Route tables for the private subnets
* 3 EIPs for each of the NAT gateway
* AWS VPC endpoint for S3


Documentation
---
1. [AWS VPC Doc](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
2. [Terraform reference](https://www.terraform.io/docs/providers/aws/r/vpc.html#)

Usage
---
#### Simple invocation
```bash
module "test_vpc" {
  source                        = "modules/vpc/main" # Relative path
  name                          = "test-vpc"
  cidr                          = "10.0.0.0/16"
  tags                          = {Name= test}
}

```
#### More detailed invocation
```bash
module "test_vpc" {
  source                        = "modules/vpc/main"
  name                          = "test-vpc"
  cidr                          = "10.0.0.0/16"
  enable_s3_endpoint            = true
  enable_nat_gateway            = true
  tags                          = {Name= test}
}


```
