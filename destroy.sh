#!/bin/bash

cd terraform

# Execute Terraform
terraform init
terraform destroy -auto-approve
