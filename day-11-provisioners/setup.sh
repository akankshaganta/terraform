#!/bin/bash

echo "Starting setup..."

# Update packages
sudo yum update -y

# Install Git
sudo yum install git -y


# Create a test file
echo "Hello from Terraform Setup Script" > /home/ec2-user/setup-success.txt

echo "Setup completed."