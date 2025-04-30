variable "name_prefix" {
  description = "Prefix for the secret names"
  type        = string
  default     = "terraform"
}

variable "create_secrets" {
  description = "Whether to create new secrets"
  type        = bool
  default     = true
}

variable "secrets" {
  description = "Map of secrets to create"
  type        = map(any)
  default     = {}
  # Example:
  # {
  #   "db-password" = {
  #     description             = "Database password"
  #     secret_string           = "supersecretpassword"
  #     recovery_window_in_days = 7
  #   }
  # }
}

variable "existing_secrets" {
  description = "Map of existing secrets to retrieve"
  type        = map(string)
  default     = {}
  # Example:
  # {
  #   "db-password" = "my-existing-secret-name"
  # }
}

variable "default_recovery_window_in_days" {
  description = "Default recovery window in days for secrets"
  type        = number
  default     = 30
}

variable "default_kms_key_id" {
  description = "Default KMS key ID to use for encrypting secrets"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}