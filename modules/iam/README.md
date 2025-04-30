# IAM Module

This module creates IAM roles and instance profiles for EC2 instances.

## Features

- IAM role with EC2 assume role policy
- IAM instance profile
- Attachment of specified IAM policies

## Usage

```hcl
module "ec2_iam" {
  source = "../../modules/iam"

  name = "example-ec2"
  
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
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
| name | Name to be used on IAM role and instance profile | `string` | n/a | yes |
| policy_arns | List of IAM Policy ARNs to attach to the IAM role | `list(string)` | `[]` | no |
| tags | A mapping of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_name | Name of the IAM role |
| role_arn | ARN of the IAM role |
| instance_profile_name | Name of the IAM instance profile |
| instance_profile_arn | ARN of the IAM instance profile |