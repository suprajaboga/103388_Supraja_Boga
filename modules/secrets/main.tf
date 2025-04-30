/**
 * # AWS Secrets Manager Module
 *
 * This module manages AWS Secrets Manager resources for storing sensitive data.
 */

# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "this" {
  for_each = var.create_secrets ? var.secrets : {}

  name                    = "${var.name_prefix}-${each.key}"
  description             = lookup(each.value, "description", "Managed by Terraform")
  recovery_window_in_days = lookup(each.value, "recovery_window_in_days", var.default_recovery_window_in_days)
  kms_key_id              = lookup(each.value, "kms_key_id", var.default_kms_key_id)

  tags = merge(
    {
      Name = "${var.name_prefix}-${each.key}"
    },
    var.tags
  )
}

# Store the secret value
resource "aws_secretsmanager_secret_version" "this" {
  for_each = var.create_secrets ? var.secrets : {}

  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = lookup(each.value, "secret_string", null)
  secret_binary = lookup(each.value, "secret_string", null) == null ? lookup(each.value, "secret_binary", null) : null

  # Only create the secret version if secret_string or secret_binary is provided
  count = lookup(each.value, "secret_string", null) != null || lookup(each.value, "secret_binary", null) != null ? 1 : 0
}

# Data source to retrieve existing secrets
data "aws_secretsmanager_secret" "existing" {
  for_each = var.existing_secrets

  name = each.value
}

data "aws_secretsmanager_secret_version" "existing" {
  for_each = var.existing_secrets

  secret_id = data.aws_secretsmanager_secret.existing[each.key].id
}