output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.foodie_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.foodie_eip.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.foodie_server.private_ip
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

output "ssh_connection_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.foodie_eip.public_ip}"
}