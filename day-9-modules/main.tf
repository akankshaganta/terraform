resource "aws_instance" "dev" {
  ami = var.ami_id
  instance_type = var.instance_type
  tags = var.tags
}

# resource "aws_vpc" "name" {
#   cidr_block = var.cidr_block
# }