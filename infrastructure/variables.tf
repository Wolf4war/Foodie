# Variables for Foodie App Infrastructure
# DevOps Assessment - Task 3: Infrastructure as Code

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"  # US East (Virginia) - Free tier eligible
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "foodie"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "key_name" {
  description = "Name of the AWS key pair for EC2 access"
  type        = string
  default     = "Foodie"
  validation {
    condition = length(var.key_name) > 0
    error_message = "Key name must be provided for EC2 SSH access."
  }
}