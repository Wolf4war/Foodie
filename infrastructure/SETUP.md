# 🚀 Setup Guide for Terraform Testing

## Prerequisites Installation

### 1. Install Terraform
```bash
# On Windows (using Chocolatey)
choco install terraform

# Or download from: https://www.terraform.io/downloads.html
# Add to PATH after extraction
```

### 2. Install AWS CLI
```bash
# On Windows
# Download from: https://aws.amazon.com/cli/
# Or use: choco install awscli
```

### 3. Configure AWS Credentials
You have several options:

#### Option A: Use AWS CLI Configure
```bash
aws configure
# Enter:
# - AWS Access Key ID
# - AWS Secret Access Key  
# - Default region: us-east-1
# - Default output format: json
```

#### Option B: Environment Variables
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

#### Option C: Create AWS Credentials File
Create `~/.aws/credentials`:
```ini
[default]
aws_access_key_id = your-access-key
aws_secret_access_key = your-secret-key
```

Create `~/.aws/config`:
```ini
[default]
region = us-east-1
output = json
```

## 🔑 AWS Key Pair Setup

### Create a Key Pair for EC2 Access
```bash
# Option 1: Using AWS CLI
aws ec2 create-key-pair --key-name foodie-dev-key --query 'KeyMaterial' --output text > ~/.ssh/foodie-dev-key.pem
chmod 400 ~/.ssh/foodie-dev-key.pem

# Option 2: Using AWS Console
# 1. Go to EC2 → Key Pairs
# 2. Create Key Pair named "foodie-dev-key"
# 3. Download the .pem file
```

## 🧪 Testing Steps

### 1. Format Code
```bash
terraform fmt
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Validate Configuration
```bash
terraform validate
```

### 4. Plan Deployment (Dry Run)
```bash
terraform plan
```

### 5. Apply Infrastructure (Deploy)
```bash
terraform apply
```

### 6. Check Outputs
```bash
terraform output
terraform output public_ip
terraform output application_url
```

### 7. Test Web Application
```bash
# Get the public IP and open in browser
curl http://$(terraform output -raw public_ip)
```

### 8. Cleanup (When Done)
```bash
terraform destroy
```

## 🔧 Troubleshooting

### Common Issues:

1. **"No valid credential sources found"**
   - Configure AWS credentials (see above)
   - Verify with: `aws sts get-caller-identity`

2. **"KeyPair does not exist"**
   - Create the key pair first
   - Update `key_name` in terraform.tfvars

3. **"terraform: command not found"**
   - Install Terraform and add to PATH

4. **"Region not supported"**
   - Use us-east-1, us-west-2, or another supported region

## 🎯 Quick Test (Minimal Setup)

If you just want to test syntax without deploying:

```bash
# 1. Format
terraform fmt

# 2. Initialize  
terraform init

# 3. Validate
terraform validate

# 4. Plan (shows what would be created)
terraform plan
```

This will verify your Terraform configuration without creating any AWS resources.