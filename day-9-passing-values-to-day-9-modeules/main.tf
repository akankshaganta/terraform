module "dev" {
  source = "../day-9-modules"
  ami_id = "ami-0152204c1a187337c"
  instance_type = "t3.micro"
  tags = {
    Name = "dev"
  }
}

# module "test" {
#   source = "../day-9-modules"
#   cidr_block = "10.0.0.0/16"
# }                             