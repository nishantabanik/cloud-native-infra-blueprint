# User Portal Infrastructure

This folder hosts the IaC to host the User portal in AWS.

### Folder structure

- `modules` - Contains base modules for creating AWS resources
- `global` - This folder contains globl AWS resources (i.e. iam or route53)
- `eu-central-1` - This folder contains base infrastructure resources that are deployed on the AWS eu-central-1 region

### How to run

To initialize and run terraform, please run:

```bash
 cd ./eu-central-1
 terraform init --backend-config backend/dev.tfvars --reconfigure
 terraform plan --var-file vars/dev.tfvars
```

### Important note: security constraints

Please follow the requirements below, in order to be able to launch EC2 instances

1. attach the following IAM policies to the instance profile

- AmazonSSMManagedInstanceCore
- RaisinHostSecurityResourcesAccessPolicy

2. Add to all instances the tag "Patch Group" with value

- "Linux" for regular instances
- "WorkerNode" for EKS worker nodes
