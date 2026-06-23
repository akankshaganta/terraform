resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = "t3.micro"
}
