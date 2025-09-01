# Global resources (for example IAM or Route53) should go in this section

### Base commands

```bash
terraform init --backend-config backend/dev.tfvars
terraform plan --var-file vars/dev.tfvars
```
