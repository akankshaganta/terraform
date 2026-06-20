resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = "t3.micro"
}
resource "aws_instance" "name2" {
  ami = var.ami_id
  instance_type = "t3.micro"
}