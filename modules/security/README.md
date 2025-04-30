# Security Module

This module creates security groups for EC2 instances and other resources.

## Features

- Create security groups with customizable ingress and egress rules
- Support for multiple ingress and egress rules
- Default egress rule allowing all outbound traffic

## Usage

```hcl
module "ec2_security_group" {
  source = "../../modules/security"

  name        = "example-ec2"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP access"
    }
  ]
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name to be used on all resources as prefix | `string` | n/a | yes |
| description | Description of the security group | `string` | `"Security group managed by Terraform"` | no |
| vpc_id | ID of the VPC where to create security group | `string` | n/a | yes |
| ingress_rules | List of ingress rules to create | `list(object)` | `[]` | no |
| egress_rules | List of egress rules to create | `list(object)` | `[{...}]` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | The ID of the security group |
| security_group_name | The name of the security group |
| security_group_vpc_id | The VPC ID of the security group |
| security_group_owner_id | The owner ID of the security group |
| security_group_description | The description of the security group |