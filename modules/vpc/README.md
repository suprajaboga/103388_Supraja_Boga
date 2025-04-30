# VPC Module

This module creates a VPC with public and private subnets across multiple availability zones.

## Features

- VPC with customizable CIDR block
- Public and private subnets across multiple availability zones
- Internet Gateway for public subnets
- Route tables for public and private subnets

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name   = "example"
  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  
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
| create_vpc | Controls if VPC should be created | `bool` | `true` | no |
| vpc_id | ID of an existing VPC to use (when create_vpc = false) | `string` | `""` | no |
| vpc_cidr | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| azs | A list of availability zones in the region | `list(string)` | `[]` | no |
| public_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| private_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnets | List of IDs of public subnets |
| private_subnets | List of IDs of private subnets |
| public_route_table_id | ID of public route table |
| private_route_table_id | ID of private route table |