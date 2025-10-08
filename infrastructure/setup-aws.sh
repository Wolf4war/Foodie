#!/bin/bash

# Quick setup script for Terraform AWS infrastructure
# This script helps you set up the infrastructure quickly

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "� Foodie AWS Free Tier Infrastructure Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 This setup uses AWS Free Tier resources (t2.micro, 8GB storage)"
echo ""

# Check prerequisites
print_status "Checking prerequisites..."

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    print_error "Terraform is not installed. Please install it from https://www.terraform.io/downloads.html"
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed. Please install it and configure with 'aws configure'"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    print_error "AWS credentials not configured. Please run 'aws configure'"
    exit 1
fi

print_success "Prerequisites check passed!"

# Navigate to terraform directory
cd infrastructure/terraform

# Check if SSH key exists
SSH_KEY_PATH="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY_PATH" ]; then
    print_warning "SSH key not found at $SSH_KEY_PATH"
    read -p "Do you want to generate a new SSH key? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Generating SSH key..."
        ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N ""
        print_success "SSH key generated at $SSH_KEY_PATH"
    else
        print_error "SSH key is required. Please generate one manually with: ssh-keygen -t rsa -b 4096"
        exit 1
    fi
fi

# Create terraform.tfvars if it doesn't exist
if [ ! -f "terraform.tfvars" ]; then
    print_status "Creating terraform.tfvars file..."
    cp terraform.tfvars.example terraform.tfvars
    
    # Get GitHub token from user
    echo ""
    print_warning "You need to provide a GitHub Personal Access Token"
    echo "Create one at: https://github.com/settings/tokens"
    echo "Required permissions: repo, workflow, admin:org"
    echo ""
    read -p "Enter your GitHub Personal Access Token: " -s GITHUB_TOKEN
    echo ""
    
    # Update the terraform.tfvars file
    sed -i.bak "s/your_github_token_here/$GITHUB_TOKEN/" terraform.tfvars
    rm terraform.tfvars.bak 2>/dev/null || true
    
    print_success "terraform.tfvars created successfully!"
    print_warning "Please review and update terraform.tfvars if needed"
else
    print_status "terraform.tfvars already exists"
fi

# Initialize Terraform
print_status "Initializing Terraform..."
terraform init

# Plan the deployment
print_status "Planning Terraform deployment..."
terraform plan -out=tfplan

echo ""
print_success "Setup completed successfully! 🎉"
echo ""
echo "Next steps:"
echo "1. Review the terraform plan above"
echo "2. If everything looks good, run: terraform apply tfplan"
echo "3. After deployment, connect to your server using the SSH command from the output"
echo "4. Set up the GitHub Actions runner on the server"
echo ""
print_success "💰 Estimated cost: $0/month (AWS Free Tier eligible!)"
echo "   • t2.micro instance: FREE (750 hours/month)"
echo "   • 8GB EBS storage: FREE (30GB/month included)" 
echo "   • Elastic IP: FREE (when attached)"
echo "   ⚠️  Charges only apply after 12 months or if limits exceeded"
echo ""

read -p "Do you want to apply the Terraform plan now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Applying Terraform plan..."
    terraform apply tfplan
    
    echo ""
    print_success "🚀 Infrastructure deployed successfully!"
    echo ""
    echo "Your server is ready! Check the output above for connection details."
else
    echo ""
    print_status "Deployment skipped. You can apply later with: terraform apply tfplan"
fi

echo ""
echo "📚 For detailed instructions, see: infrastructure/terraform/README.md"