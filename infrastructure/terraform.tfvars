# Configuration for Foodie Infrastructure
# Safe to commit - no credentials here!
# 
# AWS credentials will be set as Environment Variables in Terraform Cloud:
# - AWS_ACCESS_KEY_ID (mark as Sensitive)
# - AWS_SECRET_ACCESS_KEY (mark as Sensitive)

# Project Configuration
project_name = "foodie"
environment  = "dev"

# AWS Configuration  
aws_region = "eu-north-1"  # Europe (Stockholm)

# Network Configuration
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"

# EC2 Configuration
# Ensure this key pair exists in AWS Console (EC2 → Key Pairs)
key_name = "Terraform"