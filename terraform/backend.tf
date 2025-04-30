# This file provides a template for backend configuration
# To use this, you need to:
# 1. Create an S3 bucket for storing Terraform state
# 2. Create a DynamoDB table for state locking
# 3. Update the values below with your specific configuration

# Example S3 backend configuration
# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "path/to/terraform.tfstate"
#     region         = "us-west-2"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }

# Instructions for setting up the backend:

# 1. Create an S3 bucket:
# aws s3api create-bucket \
#   --bucket my-terraform-state-bucket \
#   --region us-west-2 \
#   --create-bucket-configuration LocationConstraint=us-west-2

# 2. Enable versioning on the S3 bucket:
# aws s3api put-bucket-versioning \
#   --bucket my-terraform-state-bucket \
#   --versioning-configuration Status=Enabled

# 3. Enable server-side encryption for the S3 bucket:
# aws s3api put-bucket-encryption \
#   --bucket my-terraform-state-bucket \
#   --server-side-encryption-configuration '{
#     "Rules": [
#       {
#         "ApplyServerSideEncryptionByDefault": {
#           "SSEAlgorithm": "AES256"
#         }
#       }
#     ]
#   }'

# 4. Create a DynamoDB table for state locking:
# aws dynamodb create-table \
#   --table-name terraform-locks \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST \
#   --region us-west-2

# 5. Initialize Terraform with the backend configuration:
# terraform init \
#   -backend-config="bucket=my-terraform-state-bucket" \
#   -backend-config="key=path/to/terraform.tfstate" \
#   -backend-config="region=us-west-2" \
#   -backend-config="dynamodb_table=terraform-locks" \
#   -backend-config="encrypt=true"