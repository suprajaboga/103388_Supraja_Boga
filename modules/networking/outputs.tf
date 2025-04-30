output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = var.create_vpc ? aws_vpc.this[0].cidr_block : null
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "ID of public route table"
  value       = var.create_vpc && length(var.public_subnets) > 0 ? aws_route_table.public[0].id : null
}

output "private_route_table_id" {
  description = "ID of private route table"
  value       = var.create_vpc && length(var.private_subnets) > 0 ? aws_route_table.private[0].id : null
}

output "ec2_security_group_id" {
  description = "ID of security group for EC2 instances"
  value       = aws_security_group.ec2.id
}

output "ec2_security_group_name" {
  description = "Name of security group for EC2 instances"
  value       = aws_security_group.ec2.name
}