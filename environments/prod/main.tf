provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    # These values must be provided via the -backend-config option with terraform init
    # bucket         = "my-terraform-state"
    # key            = "prod/terraform.tfstate"
    # region         = "us-west-2"
    # dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}

module "networking" {
  source = "../../modules/networking"

  name   = "${var.environment}-${var.project_name}"
  vpc_cidr = var.vpc_cidr
  azs      = var.availability_zones
  
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  
  ec2_sg_ingress_rules = var.ec2_sg_ingress_rules
  
  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

module "ec2_instance" {
  source = "../../modules/ec2"

  name          = "${var.environment}-${var.project_name}-instance"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.networking.public_subnets[0]
  
  security_group_ids = [module.networking.ec2_security_group_id]
  key_name           = var.key_name
  
  create_eip = var.create_eip
  
  create_iam_instance_profile = var.create_iam_instance_profile
  iam_policy_arns             = var.iam_policy_arns
  
  root_volume_size      = var.root_volume_size
  root_volume_type      = var.root_volume_type
  root_volume_encrypted = var.root_volume_encrypted
  
  user_data = var.user_data
  
  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}