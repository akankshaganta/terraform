resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = "vpc-07116667b5f83079e"
  cidr_block = "10.0.0.0/26"
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id = "vpc-07116667b5f83079e"
  cidr_block = "10.0.0.64/26"
  tags = {
    Name = "subnet-2"
  }
}

provider "aws" {
  region = "us-east-1"
}
