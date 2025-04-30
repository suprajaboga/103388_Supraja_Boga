variable "name" {
  description = "Name to be used on IAM role and instance profile"
  type        = string
}

variable "policy_arns" {
  description = "List of IAM Policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}