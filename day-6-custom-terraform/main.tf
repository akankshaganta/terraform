resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custm-vpc"
  }
}

resource "aws_subnet" "cust-public-subnet-1" {
  vpc_id = "vpc-0fa9d92eb38a7de2d"
  cidr_block = "10.0.1.0/26"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cust-public-subnet-1"
  }
}

resource "aws_subnet" "cust-private-subnet-1" {
  vpc_id = "vpc-0fa9d92eb38a7de2d"
  cidr_block = "10.0.2.0/26"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cust-private-subnet-1"
  }
}

resource "aws_subnet" "cust-public-subnet-2" {
  vpc_id = "vpc-0fa9d92eb38a7de2d"
  cidr_block = "10.0.3.0/26"
  availability_zone = "us-east-1b"
  tags = {
    Name = "cust-public-subnet-1"
  }
}

resource "aws_subnet" "cust-private-subnet-2" {
  vpc_id = "vpc-0fa9d92eb38a7de2d"
  cidr_block = "10.0.4.0/26"
  availability_zone = "us-east-1b"
  tags = {
    Name = "cust-private-subnet-2"
  }
}

#custom internet gateway
resource "aws_internet_gateway" "cust-ig" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "cust-ig"
  }
}

# custom route table for internet gateway
resource "aws_route_table" "custm-ig-rt" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custm-ig-rt"
  }
}

# edit routes
resource "aws_route" "internet-access" {
  route_table_id = aws_route_table.custm-ig-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.cust-ig.id
}

# route table - subnet associations
resource "aws_route_table_association" "public-internet-subnet-1" {
  route_table_id = aws_route_table.custm-ig-rt.id
  subnet_id = aws_subnet.cust-public-subnet-1.id
}
resource "aws_route_table_association" "public-internet-subnet-2" {
  route_table_id = aws_route_table.custm-ig-rt.id
  subnet_id = aws_subnet.cust-public-subnet-2.id
}

#nat gateway
resource "aws_nat_gateway" "custm-nat" {
  
}