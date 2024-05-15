output "study_instance" {
  value       = aws_instance.study_ec2
  description = "ec2 instance."
}

output "study_instance_public_ip" {
  value = aws_instance.study_ec2.public_ip
  description = "public ip of node"
}