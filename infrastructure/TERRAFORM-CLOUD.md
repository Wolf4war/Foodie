# 🌩️ Terraform Cloud Setup Guide

## Step 1: Create Terraform Cloud Account
1. Go to: https://app.terraform.io/
2. Sign up for a free account
3. Create a new organization (or use existing)

## Step 2: Update Configuration
1. Edit `main.tf` and replace `YOUR_ORG_NAME` with your actual organization name
2. The workspace name will be `foodie-infrastructure`

## Step 3: Set Up AWS Credentials in Terraform Cloud
1. In your Terraform Cloud workspace, go to Variables
2. Add these **Environment Variables** (marked as **Sensitive**):
   - `AWS_ACCESS_KEY_ID` = your AWS access key
   - `AWS_SECRET_ACCESS_KEY` = your AWS secret key

## Step 4: Create AWS Key Pair
You'll need an AWS key pair for EC2 SSH access:

### Option A: AWS Console
1. Go to EC2 → Key Pairs in AWS Console
2. Create new key pair named `foodie-dev-key`
3. Download the .pem file

### Option B: AWS CLI (if you have it)
```bash
aws ec2 create-key-pair --key-name foodie-dev-key --query 'KeyMaterial' --output text > foodie-dev-key.pem
```

## Step 5: Update terraform.tfvars
Update your `terraform.tfvars` file with the correct key name:
```hcl
key_name = "foodie-dev-key"  # Must match your actual AWS key pair name
```

## Step 6: Connect Repository to Terraform Cloud
1. In your workspace settings, connect to your GitHub repository
2. Set the working directory to `infrastructure/`
3. Enable automatic planning on pull requests

## Step 7: Run Plan/Apply
1. Terraform Cloud will automatically run `terraform plan` 
2. Review the plan
3. Click "Confirm & Apply" to deploy

## Benefits of Terraform Cloud
✅ No local installation required
✅ Remote state management
✅ Collaboration features
✅ Automatic plan/apply
✅ Cost estimation
✅ Policy enforcement
✅ Secure variable storage

## Alternative: Terraform Cloud CLI
If you want to use CLI with Terraform Cloud:

1. Install Terraform locally
2. Run `terraform login` to authenticate
3. Use normal terraform commands - they'll run in the cloud

## Cost: FREE
- Terraform Cloud free tier includes:
  - Up to 5 users
  - Remote state management
  - Up to 500 resources
  - Perfect for this assessment!

## Quick Test Steps
1. Push code to GitHub
2. Connect workspace to repository
3. Set AWS credentials as environment variables
4. Create AWS key pair
5. Update terraform.tfvars
6. Run plan in Terraform Cloud
7. Apply if everything looks good!