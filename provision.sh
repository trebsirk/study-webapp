#!/bin/bash

cd terraform

terraform init
terraform fmt -check
terraform plan -input=false
terraform apply -auto-approve -input=false

# Get EC2 public IP from Terraform output
EC2_PUBLIC_IP=$(terraform output study_instance_public_ip)
echo "EC2_PUBLIC_IP: $EC2_PUBLIC_IP"

# Run Ansible playbook to configure the EC2 instance
# ansible-playbook -i "$EC2_PUBLIC_IP," playbook.yml
