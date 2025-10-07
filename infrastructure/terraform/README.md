# AWS Infrastructure Setup with Terraform

This directory contains Terraform configuration to provision AWS infrastructure for the Foodie application, including:

- **Ubuntu EC2 instance** with all necessary tools
- **VPC and networking components** (VPC, subnet, internet gateway, route table)
- **Security group** allowing HTTP/HTTPS traffic and SSH access
- **Elastic IP** for static IP address
- **Pre-configured GitHub Actions runner setup**

## Prerequisites

1. **AWS Free Tier Account** - [Sign up here](https://aws.amazon.com/free/) if you haven't already
   - Must be within the 12-month free tier period
   - Verify your account has free tier benefits available

2. **AWS CLI configured** with appropriate credentials:
   ```bash
   aws configure
   ```

3. **Terraform installed** (version >= 1.0):
   - Download from [terraform.io](https://www.terraform.io/downloads.html)

4. **SSH key pair generated**:
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
   ```

5. **GitHub Personal Access Token** with the following permissions:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
   - `admin:org` (Full control of orgs and teams, read and write org projects)

## Setup Instructions

### 1. Configure Variables

Copy the example variables file and update it with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update:
- `aws_region`: Your preferred AWS region
- `public_key_path`: Path to your SSH public key
- Other variables as needed

### 2. Set GitHub Token Securely

**IMPORTANT**: Never put your GitHub token in terraform.tfvars as it will be committed to git!

Set your GitHub token as an environment variable:

**PowerShell (Windows):**
```powershell
$env:TF_VAR_github_token = "your_github_token_here"
```

**Bash/WSL (Linux/Mac):**
```bash
export TF_VAR_github_token="your_github_token_here"
```

**Alternative: Use .env file (not committed to git):**
```bash
cp .env.example .env
# Edit .env file with your token
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan the Deployment

```bash
terraform plan
```

Review the planned changes to ensure everything looks correct.

### 4. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### 5. Get Connection Information

After successful deployment, Terraform will output:
- **Public IP address** of your server
- **SSH connection command**
- **Instance ID** and other resource information

## Connecting to Your Server

Use the SSH command from the Terraform output:

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<PUBLIC_IP>
```

## Setting Up GitHub Actions Runner

Once connected to your server, you'll see a welcome message with instructions. Follow these steps:

### 1. Navigate to the runner directory:
```bash
cd /home/ubuntu/actions-runner
```

### 2. Configure the runner:
```bash
./config.sh --url https://github.com/Wolf4war/Foodie --token <YOUR_GITHUB_TOKEN>
```

### 3. Start the runner:
```bash
./run.sh
```

### 4. (Optional) Run as a service:
To run the runner as a background service:
```bash
sudo systemctl enable github-actions-runner
sudo systemctl start github-actions-runner
sudo systemctl status github-actions-runner
```

## Pre-installed Software

The server comes with the following software pre-installed:
- **Docker & Docker Compose** - For containerization
- **Node.js 18 & npm** - For running your Vue.js application
- **Nginx** - Web server configured to proxy to port 3000
- **Git** - Version control
- **Build tools** - For compiling applications

## Server Configuration

### Nginx Configuration
- Configured to proxy requests from port 80 to localhost:3000
- Suitable for serving your Vue.js application
- SSL can be added later with Let's Encrypt

### Security Groups
The server allows inbound traffic on:
- **Port 22** (SSH)
- **Port 80** (HTTP)
- **Port 443** (HTTPS)
- **Port 3000** (Application)
- **Port 5173** (Vite dev server)

### Network Setup
- **VPC**: 10.0.0.0/16
- **Public Subnet**: 10.0.1.0/24
- **Static Public IP**: Allocated via Elastic IP
- **Internet Gateway**: For public internet access

## 🆓 AWS Free Tier Benefits

This setup is designed to work within AWS Free Tier limits:

### What's FREE (for 12 months):
- ✅ **t2.micro EC2 instance** - 750 hours/month (24/7 usage)
- ✅ **8GB EBS storage** - Up to 30GB free
- ✅ **VPC & Networking** - Always free
- ✅ **Elastic IP** - Free when attached to running instance
- ✅ **Data Transfer** - 15GB outbound per month

### Potential Charges:
- ⚠️ **Elastic IP when detached** - $0.005/hour if instance is stopped
- ⚠️ **EBS storage over 30GB** - $0.10/GB/month
- ⚠️ **Data transfer over 15GB** - $0.09/GB
- ⚠️ **After 12 months** - Standard EC2 pricing (~$8.5/month for t2.micro)

### 💡 Cost Optimization Tips:
1. **Stop instance when not needed** - No charges while stopped (except EBS)
2. **Monitor data usage** - Keep outbound data under 15GB/month
3. **Release Elastic IP** - If you stop the instance for extended periods
4. **Set billing alerts** - Get notified if charges exceed $1

## Using in GitHub Actions

Update your GitHub Actions workflow to use the self-hosted runner:

```yaml
name: Deploy to Self-Hosted Runner

on:
  push:
    branches: [ master ]

jobs:
  deploy:
    runs-on: self-hosted
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install dependencies
      run: npm install
    
    - name: Build application
      run: npm run build
    
    - name: Deploy with Docker
      run: |
        docker-compose down
        docker-compose up -d --build
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction.

## Troubleshooting

### Can't connect via SSH
1. Check security group rules in AWS console
2. Verify your SSH key pair is correct
3. Ensure the instance is in "running" state

### GitHub Actions runner not connecting
1. Verify the GitHub token has correct permissions
2. Check the runner logs: `sudo journalctl -u github-actions-runner -f`
3. Ensure the repository URL is correct

### Application not accessible
1. Check if your application is running on port 3000
2. Verify Nginx configuration: `sudo nginx -t`
3. Check Nginx status: `sudo systemctl status nginx`

## Security Considerations

1. **SSH Keys**: Keep your private key secure and never share it
2. **GitHub Token**: Store securely and rotate regularly
3. **Security Groups**: Consider restricting SSH access to your IP only
4. **Updates**: Regularly update the server packages

## 💰 Cost Breakdown (Free Tier)

### First 12 Months (FREE):
- ✅ **t2.micro instance**: $0 (750 hours/month included)
- ✅ **8GB EBS storage**: $0 (30GB/month included)  
- ✅ **Elastic IP**: $0 (when attached to running instance)
- ✅ **VPC & Networking**: $0 (always free)
- ✅ **Data transfer**: $0 (first 15GB/month included)

### **Total Cost: $0/month** (within free tier limits)

### After 12 Months:
- **t2.micro instance**: ~$8.50/month
- **8GB EBS storage**: ~$0.80/month
- **Elastic IP**: $0 (when attached)
- **Data transfer**: $0.09/GB over 15GB

### **Total after free tier**: ~$9.30/month

### ⚠️ Potential Extra Charges:
- **Elastic IP when detached**: $0.005/hour (~$3.60/month if always detached)
- **EBS snapshots**: $0.05/GB/month (if you create backups)
- **Excess data transfer**: $0.09/GB over 15GB/month

## Customization

You can customize the setup by modifying:
- `variables.tf`: Change default values
- `main.tf`: Modify resources or add new ones
- `user_data.sh`: Add more software or configuration
- Security group rules for different port access

For more advanced setups, consider:
- Adding an Application Load Balancer
- Setting up auto-scaling groups
- Implementing backup strategies
- Adding monitoring and logging