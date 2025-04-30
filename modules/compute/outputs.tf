output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = var.create_eip ? aws_eip.this[0].public_ip : aws_instance.this.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}

output "instance_security_groups" {
  description = "Security groups attached to the instance"
  value       = aws_instance.this.security_groups
}