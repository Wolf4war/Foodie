#!/bin/bash
# Quick setup script for Terraform testing

echo "🚀 Foodie Infrastructure Setup"
echo "=============================="

# Check current directory
echo "📂 Current directory: $(pwd)"
echo "📁 Files available:"
ls -la *.tf *.tfvars* 2>/dev/null || echo "No .tf files found"

echo ""
echo "📋 Next Steps:"
echo "1. Install Terraform: https://www.terraform.io/downloads.html"
echo "2. Install AWS CLI: https://aws.amazon.com/cli/"
echo "3. Configure AWS credentials"
echo "4. Create AWS key pair"
echo "5. Update terraform.tfvars with your key name"

echo ""
echo "🧪 Testing Commands (after setup):"
echo "terraform fmt        # Format code"
echo "terraform init       # Initialize"
echo "terraform validate   # Check syntax"
echo "terraform plan       # Preview changes"

echo ""
echo "📖 See SETUP.md for detailed instructions"