output "secret_arns" {
  description = "ARNs of the created secrets"
  value       = { for k, v in aws_secretsmanager_secret.this : k => v.arn }
}

output "secret_ids" {
  description = "IDs of the created secrets"
  value       = { for k, v in aws_secretsmanager_secret.this : k => v.id }
}

output "existing_secret_arns" {
  description = "ARNs of the existing secrets"
  value       = { for k, v in data.aws_secretsmanager_secret.existing : k => v.arn }
}

output "existing_secret_ids" {
  description = "IDs of the existing secrets"
  value       = { for k, v in data.aws_secretsmanager_secret.existing : k => v.id }
}

output "secret_values" {
  description = "Map of secret keys to their current version"
  value = {
    for k, v in data.aws_secretsmanager_secret_version.existing : k => jsondecode(v.secret_string)
  }
  sensitive = true
}