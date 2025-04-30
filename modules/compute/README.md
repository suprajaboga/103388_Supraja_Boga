# Compute Module

This module creates EC2 instances with customizable configuration.

## Features

- EC2 instance with customizable configuration
- Root volume with encryption
- Elastic IP (optional)

## Usage

```hcl
module "ec2_instance" {
  source = "../../modules/compute"

  name          = "example-instance"
  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]
  
  security_group_ids = [module.security.security_group_id]
  key_name           = "my-key-pair"
  
  create_eip = true
  
  iam_instance_profile_name = module.iam.instance_profile_name
  
  root_volume_size      = 20
  root_volume_type      = "gp3"
  root_volume_encrypted = true
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name to be used on EC2 instance created | `string` | n/a | yes |
| ami_id | ID of AMI to use for the instance | `string` | n/a | yes |
| instance_type | The type of instance to start | `string` | `"t3.micro"` | no |
| subnet_id | The VPC Subnet ID to launch in | `string` | n/a | yes |
| security_group_ids | A list of security group IDs to associate with | `list(string)` | `[]` | no |
| key_name | Key name of the Key Pair to use for the instance | `string` | `null` | no |
| user_data | The user data to provide when launching the instance | `string` | `null` | no |
| root_volume_type | The type of volume for the root block device | `string` | `"gp3"` | no |
| root_volume_size | The size of the volume in gigabytes | `number` | `20` | no |
| root_volume_delete_on_termination | Whether the volume should be destroyed on instance termination | `bool` | `true` | no |
| root_volume_encrypted | Whether to encrypt the root block device | `bool` | `true` | no |
| create_eip | Whether to create an Elastic IP for the instance | `bool` | `false` | no |
| iam_instance_profile_name | Name of the IAM instance profile to attach to the instance | `string` | `null` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| instance_arn | ARN of the EC2 instance |
| instance_public_ip | Public IP address of the EC2 instance |
| instance_private_ip | Private IP address of the EC2 instance |
| instance_security_groups | Security groups attached to the instance |