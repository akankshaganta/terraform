resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
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

resource "aws_subnet" "cust-public-subnet-2" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.2.0/26"
  availability_zone = "us-east-1b"
  tags = {
    Name = "cust-public-subnet-2"
  }
}

resource "aws_subnet" "cust-pvt-subnet-1" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.3.0/26"
  availability_zone = "us-east-1a"
  tags = {
    Name = "cust-pvt-subnet-1"
  }
}

resource "aws_subnet" "cust-pvt-subnet-2" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.4.0/26"
  availability_zone = "us-east-1b"
  tags = {
    Name = "cust-pvt-subnet-2"
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

# custom sg
resource "aws_security_group" "custom-sg" {
  name = "custom-sg"
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
    Name = "custom-sg"
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
  vpc_security_group_ids = [ aws_security_group.custom-sg.id ]
  subnet_id = aws_subnet.cust-public-subnet-1.id
  associate_public_ip_address = true
  tags = {
    Name = "public-server"
  }
}

resource "aws_security_group" "cust-rds-sg" {
  name = "cust-rds-sg"
  vpc_id = aws_vpc.custom_vpc.id
  description = "allow"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cust-rds-sg"
  }
}

resource "aws_db_subnet_group" "subnet-group" {
  name = "db-instance-subnet-group"
  subnet_ids = [aws_subnet.cust-pvt-subnet-1.id,
                aws_subnet.cust-pvt-subnet-2.id  ]
    tags = {
      Name = "db-instance-subnet-group"
    }
}

resource "aws_db_instance" "db-instance" {
  identifier = "cust-rds" #db name
  engine = "mysql"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "123456789"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = false
  db_subnet_group_name = aws_db_subnet_group.subnet-group.name
  vpc_security_group_ids = [aws_security_group.cust-rds-sg.id]
  tags = {
    Name = "db-instance"
  }
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
}

resource "null_resource" "remote_sql_execution" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/ayyap/.ssh/id_ed25519")
    host        = aws_instance.public-server.public_ip
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "init.sql"
    destination = "/home/ec2-user/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mariadb105",

      "mysql --version",

      # Execute SQL script
      "mysql -h ${aws_db_instance.db-instance.address} -u admin -p'123456789' < /home/ec2-user/init.sql",

      # Verify database and tables
      "mysql -h ${aws_db_instance.db-instance.address} -u admin -p'123456789' -e 'SHOW DATABASES;'",
      "mysql -h ${aws_db_instance.db-instance.address} -u admin -p'123456789' -e 'USE dev; SHOW TABLES;'"
    ]
  }

  triggers = {
    sql_hash = filesha256("init.sql")
  }
}


