# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Use specific Ubuntu AMI ID
# AMI: ami-0360c520857e3138f (Ubuntu 22.04 LTS)
locals {
  ubuntu_ami_id = "ami-0360c520857e3138f"
}

# Create VPC
resource "aws_vpc" "foodie_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "foodie-vpc"
    Environment = var.environment
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "foodie_igw" {
  vpc_id = aws_vpc.foodie_vpc.id

  tags = {
    Name = "foodie-igw"
    Environment = var.environment
  }
}

# Create Public Subnet
resource "aws_subnet" "foodie_public_subnet" {
  vpc_id                  = aws_vpc.foodie_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "foodie-public-subnet"
    Environment = var.environment
  }
}

# Get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create Route Table
resource "aws_route_table" "foodie_public_rt" {
  vpc_id = aws_vpc.foodie_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.foodie_igw.id
  }

  tags = {
    Name = "foodie-public-rt"
    Environment = var.environment
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "foodie_public_rta" {
  subnet_id      = aws_subnet.foodie_public_subnet.id
  route_table_id = aws_route_table.foodie_public_rt.id
}

# Create Security Group
resource "aws_security_group" "foodie_sg" {
  name        = "foodie-security-group"
  description = "Security group for Foodie application server"
  vpc_id      = aws_vpc.foodie_vpc.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Custom port for your application (if needed)
  ingress {
    description = "Custom App Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Vite dev server port (if needed)
  ingress {
    description = "Vite Dev Server"
    from_port   = 5173
    to_port     = 5173
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
    Name = "foodie-sg"
    Environment = var.environment
  }
}

# Create Key Pair
resource "aws_key_pair" "foodie_key" {
  key_name   = "foodie-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "foodie-key"
    Environment = var.environment
  }
}

# Allocate Elastic IP
resource "aws_eip" "foodie_eip" {
  instance = aws_instance.foodie_server.id
  domain   = "vpc"

  tags = {
    Name = "foodie-development-eip"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.foodie_igw]
}

# Create EC2 Instance
resource "aws_instance" "foodie_server" {
  ami                    = local.ubuntu_ami_id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.foodie_key.key_name
  vpc_security_group_ids = [aws_security_group.foodie_sg.id]
  subnet_id             = aws_subnet.foodie_public_subnet.id

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    encrypted   = false
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    github_repo_url = var.github_repo_url
    github_token    = var.github_token
  }))

  tags = {
    Name = "foodie-development"
    Environment = var.environment
    # Test deployment with foodie-development runner
  }
}