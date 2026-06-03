resource "aws_vpc" "vpc_create" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "new-vpc"
  }
}

resource "aws_subnet" "name" {
  vpc_id = "vpc-0ade92c9158f0e696"
  cidr_block = "10.0.0.64/26"
  tags = {  Name="custom-subnet"}
}

resource "aws_subnet" "name2" {
  vpc_id = "vpc-0ade92c9158f0e696"
  cidr_block = "10.0.0.128/26"
  tags = {
    Name="custom-subnet2"
  }
}


provider "aws" {
  
}