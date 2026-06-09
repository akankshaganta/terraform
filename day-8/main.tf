resource "aws_vpc" "dev-vpc" {
   cidr_block = "10.0.0.0/24"
   tags = {
     Name = "dev-vpc"
   }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.0.0/26"
  tags = {
    Name = "subnet-1"
  }
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.0.64/26"
  tags = {
    Name = "subnet-2"
  }
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "dev-subnet-group" {
  subnet_ids = [ aws_subnet.subnet-1.id,aws_subnet.subnet-2.id]
  tags = {
    Name = "dev-subnet-group"
  }
}

resource "aws_security_group" "dev-rds-sg" {
  tags = {
    Name="dev-rds-sg"
  }
  description = "allow 3306"
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
  vpc_id = aws_vpc.dev-vpc.id
}

resource "aws_db_instance" "dev-rds" {
  identifier = "dev-rds"
  engine = "mysql"
  engine_version = "8.4.8"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_type = "gp3"
  db_name = "mydatabase"
  username = "admin"
  password = "8688048557"
  #managed_master_user_password = true #enable password management by AWS Secrets Manager
  publicly_accessible = false
  vpc_security_group_ids = [ aws_security_group.dev-rds-sg.id ]
  db_subnet_group_name = aws_db_subnet_group.dev-subnet-group.name
  skip_final_snapshot = true
  tags = {
    Name="my-rds"
  }
}