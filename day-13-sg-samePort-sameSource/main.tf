#same port diff source
resource "aws_security_group" "ec2-sg" {
  description = "allow"
  vpc_id = "vpc-0755e8223881578b0"
  ingress = [
    for port in [80,443,22]: {
        description      = "Allow port ${port}"
        from_port = port
        to_port = port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
    }
  ]
  egress = [ {
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  } ]
  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_instance" "ec2" {
  ami = "ami-0521cb2d60cfbb1a6"
  instance_type = "t3.micro"
  subnet_id = "subnet-0ebaea1582f15adbe"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
  tags = {
    Name = "ec2"
  }
  user_data = <<-EOF
                #!/bin/bash
                yum install -y nginx
                systemctl start nginx
                systemctl enable nginx
                echo "Hello, World! from NIT akanksha" > /usr/share/nginx/html/index.html
                EOF
}



