# 🌩️ Terraform Cloud Setup Guide for Foodie Infrastructure

## 🎯 Complete Step-by-Step Setup

### **Step 1: Create Terraform Cloud Account**
1. Go to: https://app.terraform.io/
2. Sign up with your GitHub account (recommended)
3. Create organization: `Wolf4War`

### **Step 2: Create Workspace**
1. Click "New Workspace"
2. Choose "Version control workflow"
3. Connect to GitHub repository: `Wolf4war/Foodie`
4. Set working directory: `infrastructure/`
5. Name workspace: `foodie-infrastructure`
6. Click "Create workspace"

### **Step 3: Configure Variables**
Go to workspace → Variables tab and add:

#### **🔐 Environment Variables** (mark as **Sensitive** ✅):
```
Variable Name: AWS_ACCESS_KEY_ID
Value: [Your-Actual-AWS-Access-Key-ID]
Category: Environment variable
Sensitive: ✅ YES

Variable Name: AWS_SECRET_ACCESS_KEY  
Value: [Your-Actual-AWS-Secret-Access-Key]
Category: Environment variable
Sensitive: ✅ YES
```

#### **⚙️ Terraform Variables** (optional overrides):
```
Variable Name: key_name
Value: Terraform
Category: Terraform variable

Variable Name: aws_region
Value: eu-north-1
Category: Terraform variable

Variable Name: project_name
Value: foodie
Category: Terraform variable

Variable Name: environment
Value: dev
Category: Terraform variable
```

### **Step 4: Workspace Settings**
1. **Execution Mode**: Remote (default)
2. **Auto Apply**: Disabled (for safety - you'll confirm manually)
3. **Terraform Version**: Latest (1.5+)

### **Step 5: Trigger First Run**
1. Push your code to GitHub (we'll do this next)
2. Terraform Cloud will automatically detect changes
3. It will create a plan
4. Review the plan carefully
5. Click "Confirm & Apply" to deploy

## 📊 **Expected Infrastructure** (AWS Free Tier)

Your deployment will create:
- ✅ **1 VPC** (10.0.0.0/16) - Free
- ✅ **1 Public Subnet** (10.0.1.0/24) - Free  
- ✅ **1 Internet Gateway** - Free
- ✅ **1 Route Table** + Association - Free
- ✅ **1 Security Group** (HTTP + SSH) - Free
- ✅ **1 EC2 t2.micro** instance - Free (750 hours/month)
- ✅ **1 Elastic IP** - Free (when attached)

**💰 Total Monthly Cost: $0.00** (within Free Tier limits)

## 🌐 **After Deployment**

You'll get outputs including:
- **Public IP**: Access your web app
- **SSH Command**: Connect to your instance  
- **Application URL**: Direct link to your Foodie app

Example:
```
application_url = "http://3.145.123.456"
ssh_command = "ssh -i ~/.ssh/Terraform.pem ec2-user@3.145.123.456"
```

## 🔒 **Security Features**

- ✅ **No credentials in code** - All stored securely in Terraform Cloud
- ✅ **Sensitive variables** - Marked as sensitive, never displayed
- ✅ **Audit trail** - All changes tracked and logged
- ✅ **Team access control** - Manage who can deploy
- ✅ **State locking** - Prevents concurrent modifications

## 🚨 **Troubleshooting**

### **Common Issues:**

**1. "Invalid AWS credentials"**
- Verify AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in Variables tab
- Ensure they're marked as "Sensitive"
- Check credentials are active in AWS Console

**2. "Key pair does not exist"** 
- Verify key pair "Terraform" exists in AWS EC2 Console
- Must be in the same region (eu-north-1)
- Create if missing: AWS Console → EC2 → Key Pairs

**3. "Working directory not found"**
- Verify working directory is set to: `infrastructure/`
- Check repository connection is working

### **Validation Steps:**
```bash
# After deployment, test your infrastructure:
curl http://[YOUR-PUBLIC-IP]
# Should return Foodie app welcome page

ssh -i ~/.ssh/Terraform.pem ec2-user@[YOUR-PUBLIC-IP]
# Should connect to your instance
```

## 🎉 **Success Criteria**

Your DevOps Assessment (Task 3) will be complete when:
- ✅ All infrastructure resources are created
- ✅ EC2 instance is running and accessible  
- ✅ Web application displays correctly
- ✅ All requirements met (VPC, subnet, security group, etc.)
- ✅ Terraform Cloud shows successful deployment
- ✅ Infrastructure is documented and reproducible

Ready to deploy! 🚀