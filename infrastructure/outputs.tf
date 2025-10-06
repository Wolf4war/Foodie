# Outputs for Foodie App Infrastructure
# DevOps Assessment - Task 3: Infrastructure as Code

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.foodie_instance.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.foodie_eip.public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.foodie_vpc.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.foodie_public_subnet.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.foodie_sg.id
}

# Additional helpful outputs
output "application_url" {
  description = "URL to access the Foodie application"
  value       = "http://${aws_eip.foodie_eip.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_eip.foodie_eip.public_ip}"
}