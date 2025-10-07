# AWS Infrastructure Provisioning

This Terraform configuration provisions AWS infrastructure for the Foodie application deployment using AWS Free Tier resources.

## Infrastructure Components

- **EC2 Instance**: t2.micro (AWS Free Tier) running Ubuntu 24.04 LTS
- **VPC**: Custom Virtual Private Cloud (10.0.0.0/16) with public subnet
- **Security Group**: Configured for HTTP/HTTPS traffic and SSH access
- **Elastic IP**: Static public IP address for consistent access
- **EBS Storage**: 8GB GP2 storage (Free Tier compatible)

## Prerequisites

- AWS CLI configured with valid credentials
- Terraform installed (v1.0+)
- SSH key pair available for EC2 access

## Deployment

1. Initialize Terraform workspace:
   ```bash
   terraform init
   ```

2. Review planned changes:
   ```bash
   terraform plan
   ```

3. Provision infrastructure:
   ```bash
   terraform apply
   ```

4. Retrieve public IP address:
   ```bash
   terraform output elastic_ip
   ```

## Architecture

The infrastructure uses AWS Free Tier resources:
- EC2 instance in public subnet with internet gateway
- Security groups controlling inbound traffic (ports 22, 80, 443)
- Elastic IP for persistent public addressing
- EBS volume for persistent storage

## Access

Connect to the provisioned server:
```bash
ssh ubuntu@<elastic_ip_from_output>
```

## Cleanup

Remove all provisioned resources:
```bash
terraform destroy
```