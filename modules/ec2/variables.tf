variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "ami_id" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "key_name_secret_id" {
  description = "Secret ID in AWS Secrets Manager containing the key name"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_secret_id" {
  description = "Secret ID in AWS Secrets Manager containing the user data script"
  type        = string
  default     = null
}

variable "root_volume_type" {
  description = "The type of volume for the root block device"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "The size of the volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination"
  type        = bool
  default     = true
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root block device"
  type        = bool
  default     = true
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the instance"
  type        = bool
  default     = false
}

variable "create_iam_instance_profile" {
  description = "Whether to create an IAM instance profile"
  type        = bool
  default     = false
}

variable "iam_instance_profile_name" {
  description = "Name of the existing IAM instance profile to attach to the instance"
  type        = string
  default     = null
}

variable "iam_policy_arns" {
  description = "List of IAM Policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}