output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.networking.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.networking.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.networking.private_subnets
}

output "ec2_security_group_id" {
  description = "ID of security group for EC2 instances"
  value       = module.networking.ec2_security_group_id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.instance_public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_instance.instance_private_ip
}