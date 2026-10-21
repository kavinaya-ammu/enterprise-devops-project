variable "aws_region" { type = string; default = "ap-south-1" }
variable "project_name" { type = string; default = "enterprise-wms-dev" }
variable "enable_demo_ec2" { description = "Explicitly enable a billable demo EC2 instance after cost review."; type = bool; default = false }
variable "allowed_ssh_cidr" { description = "Your public IP as CIDR; never use 0.0.0.0/0."; type = string; default = "127.0.0.1/32" }
