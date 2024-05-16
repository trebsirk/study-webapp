#!/bin/bash

# Define the IP address to test SSH connectivity
cd terraform
IP_ADDRESS=$(terraform output study_instance_public_ip | tr -d '"')
echo "IP=$IP_ADDRESS"
cd ..

# Define the SSH options (e.g., specify SSH key, username)
SSH_OPTIONS="-o StrictHostKeyChecking=no -i ~/.ssh/study ubuntu@${IP_ADDRESS}"

# Attempt to establish an SSH connection
ssh $SSH_OPTIONS "echo 'SSH connection successful!'"

# Check the exit status of the SSH command
if [ $? -eq 0 ]; then
  echo "SSH connection to ${IP_ADDRESS} successful."
  exit 0  # Exit with success status (0)
else
  echo "Failed to establish SSH connection to ${IP_ADDRESS}."
  exit 1  # Exit with failure status (non-zero)
fi
