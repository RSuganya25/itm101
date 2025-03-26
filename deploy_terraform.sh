#!/bin/bash

# Download the Terraform configuration file
curl -O https://your-repository-url/mainawslinuxeastApp.tf

# Initialize Terraform (downloads necessary providers and sets up environment)
terraform init

# Check the plan to see what Terraform will do
terraform plan

# Apply the Terraform configuration (create the EC2 instance and Docker container)
terraform apply -auto-approve

# Output the public IP of the EC2 instance
terraform output instance_ip
