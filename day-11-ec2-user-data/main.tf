resource "aws_instance" "name" {
  ami = "ami-0152204c1a187337c"
  instance_type = "t3.micro"
  associate_public_ip_address = true
  tags = {
    Name = "my-instance"
  }
  user_data = <<-EOF
                #!/bin/bash
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "Hello, World! from NIT akanksha" > /var/www/html/index.html
                EOF

}