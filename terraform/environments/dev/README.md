# Terraform dev environment

This intentionally small starter provisions a VPC, public subnet, IGW and route table. An EC2 instance is **disabled by default** (`enable_demo_ec2=false`). No NAT gateway or EKS cluster is provisioned by default because of cost.

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

After reviewing cost and security, enable EC2 with a tightly scoped `allowed_ssh_cidr` via a local, untracked `terraform.tfvars`. Do not use `0.0.0.0/0`. Use remote state and locking before team/production use; local state is not appropriate for collaboration. Review the plan before `apply` and the destroy plan before `destroy`.
