resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custm-vpc"
  }
}

resource "aws_subnet" "cust-public-subnet-1" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/26"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cust-public-subnet-1"
  }
}

resource "aws_subnet" "cust-private-subnet-1" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.2.0/26"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cust-private-subnet-1"
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

# bashion sg
resource "aws_security_group" "my-sg" {
  name = "my-sg"
  vpc_id = aws_vpc.custom_vpc.id
  description = "allow"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-sg"
  }
}

resource "aws_key_pair" "key2" {
  key_name = "task"
  public_key = file("C:/Users/ayyap/.ssh/id_ed25519.pub.pub")
}

resource "aws_instance" "public-server" {
  ami = "ami-0152204c1a187337c"
  instance_type = "t3.micro"
  key_name = aws_key_pair.key2.key_name
  vpc_security_group_ids = [ aws_security_group.my-sg.id ]
  subnet_id = aws_subnet.cust-public-subnet-1.id
  associate_public_ip_address = true
  tags = {
    Name = "public-server"
  }
#   #connecting to a server
#   connection {
#     type = "ssh"
#     user = "ec2-user"
#     private_key = file("C:/Users/ayyap/.ssh/id_ed25519")
#     host = self.public_ip
#     timeout = "2m"
#   }
#   provisioner "file" {
#     source = "akanksha"
#     destination = "/home/ec2-user/akanksha"
#   }
#   provisioner "remote-exec" {
#     inline = [ 
#         "touch /home/ec2-user/file200",
#         "echo 'this is 200' >> /home/ec2-user/file200"
#      ]
#   }
#   provisioner "local-exec" {
#     command = "touch file500"
#   }
}

resource "null_resource" "name" {
  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("C:/Users/ayyap/.ssh/id_ed25519")
        host = aws_instance.public-server.public_ip
        timeout = "2m"
    }
    inline = [ 
      "touch /home/ec2-user/file200",
      "echo 'hello from veera devops nareshit asdf' >> /home/ec2-user/file200"
     ]
    }
    triggers = {
      always_run = timestamp()
    }
}
resource "null_resource" "file" {
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("C:/Users/ayyap/.ssh/id_ed25519")
        host = aws_instance.public-server.public_ip
        timeout = "2m"
    }
    provisioner "file" {
        source = "akanksha"
        destination = "/home/ec2-user/akanksha"
    }    
}