# Terraform AWS EC2 Infrastructure

This repository contains Terraform code to deploy EC2 instances on AWS with best practices for code modularity and state management.

## Repository Structure

```
.
├── .github/                # GitHub specific configurations
│   └── workflows/          # GitHub Actions workflows
│       └── terraform-cicd.yml # CI/CD pipeline configuration
├── environments/           # Environment-specific configurations
│   ├── dev/                # Development environment
│   │   ├── main.tf         # Main configuration file
│   │   ├── variables.tf    # Input variables
│   │   └── outputs.tf      # Output values
│   └── prod/               # Production environment
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── modules/                # Reusable Terraform modules
│   ├── ec2/                # EC2 instance module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── networking/         # Networking module (VPC, subnets, etc.)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── terraform/              # Shared Terraform configurations
│   └── backend.tf          # Backend configuration for state management
├── .checkov.yaml           # Checkov security scanner configuration
├── .gitignore              # Git ignore file
├── .pre-commit-config.yaml # Pre-commit hooks configuration
├── .tflint.hcl             # TFLint configuration
└── README.md               # This file
```

## Features

- **Modular Design**: Separate modules for EC2 instances and networking
- **Environment Separation**: Different configurations for development and production
- **Remote State Management**: S3 backend with DynamoDB locking
- **Security Best Practices**: Encrypted volumes, IAM roles, security groups
- **Customizable**: Easily configurable through variables
- **CI/CD Pipeline**: Automated testing, validation, and deployment
- **Security Scanning**: Integrated security and compliance checks

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- S3 bucket and DynamoDB table for remote state (see setup instructions in `terraform/backend.tf`)
- GitHub repository with appropriate secrets configured for CI/CD

## CI/CD Pipeline

This repository includes a comprehensive CI/CD pipeline using GitHub Actions that performs:

### Security Scanning

- **TFSec**: Scans Terraform code for potential security issues
- **Checkov**: Performs static code analysis for infrastructure-as-code
- **TFLint**: Lints Terraform files for best practices and potential errors
- **CodeQL**: Performs static application security testing

### Terraform Validation

- **Format Check**: Ensures consistent code formatting
- **Validation**: Verifies that the Terraform code is syntactically correct and internally consistent
- **Plan**: Generates and displays execution plans for review on pull requests
- **Apply**: Automatically applies changes when code is merged to the main branch

### Workflow Configuration

The CI/CD pipeline is defined in `.github/workflows/terraform-cicd.yml` and is triggered on:
- Push to the main branch
- Pull requests targeting the main branch

### Required GitHub Secrets

To use the CI/CD pipeline, configure the following secrets in your GitHub repository:

- `AWS_ACCESS_KEY_ID`: AWS access key with permissions to deploy resources
- `AWS_SECRET_ACCESS_KEY`: Corresponding AWS secret key
- `AWS_REGION`: AWS region for deployment (e.g., us-west-2)
- `TF_STATE_BUCKET`: S3 bucket name for Terraform state
- `TF_LOCK_TABLE`: DynamoDB table name for state locking

## Developer Setup

### Pre-commit Hooks

This repository includes pre-commit hooks to ensure code quality before committing:

1. Install pre-commit:
   ```bash
   pip install pre-commit
   ```

2. Set up the hooks:
   ```bash
   pre-commit install
   ```

3. The hooks will now run automatically on `git commit`

## Usage

### Setting Up Remote State

Before using this project, set up the S3 bucket and DynamoDB table for remote state management:

```bash
# Create S3 bucket
aws s3api create-bucket \
  --bucket my-terraform-state-bucket \
  --region us-west-2 \
  --create-bucket-configuration LocationConstraint=us-west-2

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket my-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket my-terraform-state-bucket \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-west-2
```

### Deploying to Development Environment

```bash
cd environments/dev

# Initialize Terraform with remote state
terraform init \
  -backend-config="bucket=my-terraform-state-bucket" \
  -backend-config="key=dev/terraform.tfstate" \
  -backend-config="region=us-west-2" \
  -backend-config="dynamodb_table=terraform-locks" \
  -backend-config="encrypt=true"

# Plan the deployment
terraform plan -out=tfplan

# Apply the changes
terraform apply tfplan
```

### Deploying to Production Environment

```bash
cd environments/prod

# Initialize Terraform with remote state
terraform init \
  -backend-config="bucket=my-terraform-state-bucket" \
  -backend-config="key=prod/terraform.tfstate" \
  -backend-config="region=us-west-2" \
  -backend-config="dynamodb_table=terraform-locks" \
  -backend-config="encrypt=true"

# Plan the deployment
terraform plan -out=tfplan

# Apply the changes
terraform apply tfplan
```

## Customization

Each environment has its own `variables.tf` file where you can customize:

- AWS region
- VPC and subnet configurations
- EC2 instance type and AMI
- Security group rules
- Volume sizes and types
- IAM policies
- And more...

## Modules

### EC2 Module

The EC2 module (`modules/ec2`) creates:
- EC2 instance with customizable configuration
- IAM role and instance profile (optional)
- Elastic IP (optional)
- Root volume with encryption

### Networking Module

The networking module (`modules/networking`) creates:
- VPC with customizable CIDR block
- Public and private subnets across multiple availability zones
- Internet Gateway and route tables
- Security groups for EC2 instances

## Best Practices Implemented

1. **Code Modularity**:
   - Separation of concerns with dedicated modules
   - Reusable components with clear interfaces
   - DRY (Don't Repeat Yourself) principle

2. **State Management**:
   - Remote state storage in S3
   - State locking with DynamoDB
   - Separate state files per environment

3. **Security**:
   - Encrypted root volumes
   - IAM roles with least privilege
   - Security groups with restricted access
   - SSH access control

4. **Environment Isolation**:
   - Separate configurations for dev and prod
   - Environment-specific variable defaults
   - Consistent naming with environment prefixes

5. **Documentation**:
   - Comprehensive README
   - Code comments
   - Variable descriptions

## License

This project is licensed under the MIT License.
