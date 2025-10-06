# Terraform Configuration for Foodie App Infrastructure
# Simple EC2-based setup for DevOps Assessment (Task 3)

terraform {
  required_version = ">= 1.0"
  
  # Terraform Cloud Configuration
  cloud {
    organization = "YOUR_ORG_NAME"  # Replace with your Terraform Cloud org name
    
    workspaces {
      name = "foodie-infrastructure"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}    # Configure AWS Provider
    provider "aws" {
    region = var.aws_region
    }

    # Data source to get the latest Amazon Linux 2 AMI
    data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    }

    # VPC
    resource "aws_vpc" "foodie_vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name        = "${var.project_name}-vpc"
        Environment = var.environment
        Project     = var.project_name
    }
    }

    # Internet Gateway
    resource "aws_internet_gateway" "foodie_igw" {
    vpc_id = aws_vpc.foodie_vpc.id

    tags = {
        Name        = "${var.project_name}-igw"
        Environment = var.environment
        Project     = var.project_name
    }
    }

    # Public Subnet
    resource "aws_subnet" "foodie_public_subnet" {
    vpc_id                  = aws_vpc.foodie_vpc.id
    cidr_block              = var.public_subnet_cidr
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name        = "${var.project_name}-public-subnet"
        Environment = var.environment
        Project     = var.project_name
        Type        = "Public"
    }
    }

    # Data source for availability zones
    data "aws_availability_zones" "available" {
    state = "available"
    }

    # Route Table for Public Subnet
    resource "aws_route_table" "foodie_public_rt" {
    vpc_id = aws_vpc.foodie_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.foodie_igw.id
    }

    tags = {
        Name        = "${var.project_name}-public-rt"
        Environment = var.environment
        Project     = var.project_name
    }
    }

    # Route Table Association
    resource "aws_route_table_association" "foodie_public_rta" {
    subnet_id      = aws_subnet.foodie_public_subnet.id
    route_table_id = aws_route_table.foodie_public_rt.id
    }

    # Security Group
    resource "aws_security_group" "foodie_sg" {
    name        = "${var.project_name}-sg"
    description = "Security group for Foodie EC2 instance"
    vpc_id      = aws_vpc.foodie_vpc.id

    # HTTP access
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # SSH access
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # All outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "${var.project_name}-sg"
        Environment = var.environment
        Project     = var.project_name
    }
    }

    # EC2 Instance
    resource "aws_instance" "foodie_instance" {
    ami                    = data.aws_ami.amazon_linux.id
    instance_type          = "t2.micro"
    key_name               = var.key_name
    subnet_id              = aws_subnet.foodie_public_subnet.id
    vpc_security_group_ids = [aws_security_group.foodie_sg.id]

    user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        
        # Create a simple HTML page
        cat > /var/www/html/index.html << 'HTML'
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Foodie App - DevOps Assessment</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
                .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                h1 { color: #e74c3c; text-align: center; }
                .status { background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin: 20px 0; }
                .info { background: #d1ecf1; color: #0c5460; padding: 10px; border-radius: 5px; margin: 10px 0; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🍽️ Foodie App</h1>
                <div class="status">
                    ✅ Infrastructure Successfully Deployed!
                </div>
                <div class="info">
                    <strong>DevOps Assessment - Task 3: Infrastructure as Code</strong><br>
                    EC2 Instance is running and accessible via HTTP
                </div>
                <div class="info">
                    <strong>Instance Details:</strong><br>
                    • Instance Type: t2.micro (Free Tier)<br>
                    • OS: Amazon Linux 2<br>
                    • Web Server: Apache HTTP Server<br>
                    • Status: Active ✅
                </div>
                <p><strong>Server Time:</strong> $(date)</p>
            </div>
        </body>
        </html>
    HTML
        
        # Set proper permissions
        chown -R apache:apache /var/www/html
        chmod -R 755 /var/www/html
    EOF

    tags = {
        Name        = "${var.project_name}-instance"
        Environment = var.environment
        Project     = var.project_name
        Type        = "WebServer"
    }
    }

    # Elastic IP
    resource "aws_eip" "foodie_eip" {
    instance = aws_instance.foodie_instance.id
    domain   = "vpc"

    tags = {
        Name        = "${var.project_name}-eip"
        Environment = var.environment
        Project     = var.project_name
    }

    depends_on = [aws_internet_gateway.foodie_igw]
    }