resource "aws_vpc" "vpc_create" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "dev-vpc"
  }
}


provider "aws" {
  
}