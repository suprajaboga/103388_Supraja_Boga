/**
 * # Compute Module
 *
 * This module creates EC2 instances with customizable configuration.
 */

# Data sources to retrieve secrets from AWS Secrets Manager
data "aws_secretsmanager_secret" "key_name" {
  count = var.key_name_secret_id != null ? 1 : 0
  name  = var.key_name_secret_id
}

data "aws_secretsmanager_secret_version" "key_name" {
  count     = var.key_name_secret_id != null ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.key_name[0].id
}

data "aws_secretsmanager_secret" "user_data" {
  count = var.user_data_secret_id != null ? 1 : 0
  name  = var.user_data_secret_id
}

data "aws_secretsmanager_secret_version" "user_data" {
  count     = var.user_data_secret_id != null ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.user_data[0].id
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name_secret_id != null ? jsondecode(data.aws_secretsmanager_secret_version.key_name[0].secret_string)["key_name"] : var.key_name
  iam_instance_profile   = var.iam_instance_profile_name

  user_data = var.user_data_secret_id != null ? jsondecode(data.aws_secretsmanager_secret_version.user_data[0].secret_string)["user_data"] : var.user_data

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_volume_delete_on_termination
    encrypted             = var.root_volume_encrypted
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )

  volume_tags = merge(
    {
      Name = var.name
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "this" {
  count    = var.create_eip ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"
  tags     = var.tags
}