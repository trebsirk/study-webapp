#!/bin/bash

cd terraform

# Execute Terraform
terraform apply -auto-approve

# Get EC2 public IP from Terraform output
EC2_PUBLIC_IP=$(terraform output instance-study)
echo "EC2_PUBLIC_IP: $EC2_PUBLIC_IP"

# Run Ansible playbook to configure the EC2 instance
# ansible-playbook -i "$EC2_PUBLIC_IP," playbook.yml
