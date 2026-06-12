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
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.3.0/26"
  availability_zone = "us-east-1b"
  tags = {
    Name = "cust-public-subnet-1"
  }
}

resource "aws_subnet" "cust-private-subnet-2" {
  vpc_id = aws_vpc.custom_vpc.id
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

# nat gateway
resource "aws_nat_gateway" "custm-nat" {
  tags = {
    Name = "cust-nat"
  }
  availability_mode = "regional"
  vpc_id = aws_vpc.custom_vpc.id
}

# nat route table
resource "aws_route_table" "custm-nat-rt" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custm-nat-rt"
  }
}

# edit routes
resource "aws_route" "secure-internet" {
  route_table_id = aws_route_table.custm-nat-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.custm-nat.id
}

# route table - subnet associations
resource "aws_route_table_association" "peivate-internet-subnet-1" {
  route_table_id = aws_route_table.custm-nat-rt.id
  subnet_id = aws_subnet.cust-private-subnet-1.id
}
resource "aws_route_table_association" "private-internet-subnet-2" {
  route_table_id = aws_route_table.custm-nat-rt.id
  subnet_id = aws_subnet.cust-private-subnet-2.id
}

# bashion sg
resource "aws_security_group" "bashion-sg" {
  name = "bashion-sg"
  vpc_id = aws_vpc.custom_vpc.id
  description = "allow"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bashion-sg"
  }
}

# private-server sg
resource "aws_security_group" "private-server-sg" {
  name = "private-server-sg"
  vpc_id = aws_vpc.custom_vpc.id
  description = "allow"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "private-server-sg"
  }
}

resource "aws_instance" "bashion" {
  tags = {
    Name = "bashion"
  }
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.cust-public-subnet-1.id
  vpc_security_group_ids =[aws_security_group.bashion-sg.id]
  associate_public_ip_address = true
  key_name = "key"
}

# private server
resource "aws_instance" "private-server" {
  tags = {
    Name = "private-server"
  }
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.cust-private-subnet-1.id
  vpc_security_group_ids =[aws_security_group.private-server-sg.id]
  associate_public_ip_address = false
  key_name = "key"
}