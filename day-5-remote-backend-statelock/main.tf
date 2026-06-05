resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "dev-vpc"
  }
}


resource "aws_subnet" "subnet-1" {
  vpc_id = "vpc-04c5167a57089b9bf"
  cidr_block = "10.0.0.0/26"
  tags = {
    Name = "subnt-1"
  }
}
resource "aws_subnet" "subnet-2" { 

  vpc_id = "vpc-04c5167a57089b9bf"

  cidr_block = "10.0.0.128/26" 

  tags = {

    Name = "subnt-2" 


  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id = "vpc-04c5167a57089b9bf"
  cidr_block = "10.0.0.192/26"
  tags = {
    Name = "subnet-3"
  }
}

provider "aws" {
  
}
