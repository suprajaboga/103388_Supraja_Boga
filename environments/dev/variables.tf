variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "demo"
}

# Networking variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ec2_sg_ingress_rules" {
  description = "List of ingress rules for EC2 security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP access"
    }
  ]
}

# EC2 variables
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 AMI ID
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "key_name_secret_id" {
  description = "Secret ID in AWS Secrets Manager containing the key name"
  type        = string
  default     = null
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the instance"
  type        = bool
  default     = true
}

variable "create_iam_instance_profile" {
  description = "Whether to create an IAM instance profile"
  type        = bool
  default     = true
}

variable "iam_policy_arns" {
  description = "List of IAM Policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
  default     = null
}

variable "user_data_secret_id" {
  description = "Secret ID in AWS Secrets Manager containing the user data script"
  type        = string
  default     = null
}

# Secrets Manager variables
variable "create_secrets" {
  description = "Whether to create secrets in AWS Secrets Manager"
  type        = bool
  default     = false
}

variable "secrets" {
  description = "Map of secrets to create in AWS Secrets Manager"
  type        = map(any)
  default     = {}
}

variable "existing_secrets" {
  description = "Map of existing secrets to retrieve from AWS Secrets Manager"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Project     = "demo"
    ManagedBy   = "terraform"
  }
}