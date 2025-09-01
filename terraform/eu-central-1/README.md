# Regional and base infrastructure resources for the Frankfurt region should be created in this section
This section is coonfigured to read outputs fromthe global section state file

### Base commands

```bash
terraform init --backend-config backend/dev.tfvars
terraform plan --var-file vars/dev.tfvars
```

