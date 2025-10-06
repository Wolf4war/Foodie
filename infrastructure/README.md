# 🏗️ Foodie Infrastructure - DevOps Assessment

This directory contains Terraform Infrastructure as Code (IaC) for **Task 3: Infrastructure as Code** of the DevOps Assessment.

## 📋 Requirements Met

✅ **AWS Cloud Provider**  
✅ **VPC** with CIDR 10.0.0.0/16  
✅ **1 Public Subnet** with CIDR 10.0.1.0/24  
✅ **Internet Gateway**  
✅ **Route Table** and association  
✅ **Security Group** allowing HTTP (80) and SSH (22)  
✅ **EC2 Instance** (t2.micro, Free Tier eligible)  
✅ **Elastic IP** attached to the instance  
✅ **Variables** for region, project_name, key_name, and CIDRs  
✅ **Meaningful tags** on all resources  
✅ **Required outputs**: instance_id, public_ip, vpc_id, subnet_id, security_group_id  

## 🗂️ File Structure

```
infrastructure/
├── main.tf                    # Main infrastructure resources
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example configuration
├── .gitignore                 # Terraform gitignore
└── README.md                  # This file
```

## 🚀 Quick Start

### 1. Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- An existing AWS Key Pair for EC2 SSH access

### 2. Configuration

```bash
# Copy and customize the configuration
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your AWS key pair name
vim terraform.tfvars
```

**Important**: Update the `key_name` variable with your actual AWS key pair name!

### 3. Deploy Infrastructure

```bash
# Format Terraform code
terraform fmt

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply infrastructure
terraform apply
```

### 4. Access Your Application

After successful deployment:

```bash
# Get the public IP
terraform output public_ip

# Access the web application
# Open http://[PUBLIC_IP] in your browser

# SSH to the instance (if needed)
terraform output ssh_command
```

## 📊 Infrastructure Components

### Networking
- **VPC**: 10.0.0.0/16 with DNS resolution enabled
- **Public Subnet**: 10.0.1.0/24 in first availability zone
- **Internet Gateway**: Provides internet access
- **Route Table**: Routes traffic to/from internet

### Security
- **Security Group**: 
  - Inbound: HTTP (80), SSH (22) from anywhere
  - Outbound: All traffic allowed

### Compute
- **EC2 Instance**: t2.micro (Free Tier eligible)
- **Operating System**: Amazon Linux 2
- **Web Server**: Apache HTTP Server (auto-installed)
- **Elastic IP**: Static public IP address

## 🔧 Configuration Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region for deployment | `us-east-1` | No |
| `project_name` | Project name prefix | `foodie` | No |
| `environment` | Environment tag | `dev` | No |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` | No |
| `public_subnet_cidr` | Public subnet CIDR | `10.0.1.0/24` | No |
| `key_name` | AWS key pair name | - | **Yes** |

## 📈 Outputs

After deployment, you'll get these outputs:

```bash
# Required outputs (per assessment requirements)
terraform output instance_id        # EC2 instance ID
terraform output public_ip          # Public IP address
terraform output vpc_id             # VPC ID
terraform output subnet_id          # Subnet ID
terraform output security_group_id  # Security Group ID

# Additional helpful outputs
terraform output application_url    # Direct web URL
terraform output ssh_command        # SSH connection command
```

## 💰 Cost Information

**Free Tier Eligible**: This infrastructure uses only AWS Free Tier services:
- **EC2 t2.micro**: 750 hours/month free for 12 months
- **Elastic IP**: Free when attached to running instance
- **VPC/Networking**: Always free

**Estimated Cost**: $0/month (within Free Tier limits)

## 🧪 Testing Commands

```bash
# Format code
terraform fmt

# Initialize
terraform init

# Validate syntax
terraform validate

# Plan changes
terraform plan

# Check outputs
terraform output
```

## 🔍 Verification

### Web Application Test
1. Get public IP: `terraform output public_ip`
2. Open browser: `http://[PUBLIC_IP]`
3. Should see "Foodie App" welcome page

### SSH Access Test
1. Get SSH command: `terraform output ssh_command`
2. Connect to instance: `ssh -i ~/.ssh/[key].pem ec2-user@[PUBLIC_IP]`
3. Check web server: `sudo systemctl status httpd`

## 🧹 Cleanup

```bash
# Destroy all resources
terraform destroy
```

## 📝 Assessment Notes

This infrastructure meets all requirements for **Task 3: Infrastructure as Code**:
- ✅ Simple and focused on specified resources only
- ✅ Uses AWS Free Tier eligible services
- ✅ Properly tagged and documented
- ✅ Includes all required outputs
- ✅ Safe to deploy without unexpected charges