variable "env" {
  type = list(string)
  default = [ "dev","prod" ]
}

resource "aws_instance" "name" {
  ami = "ami-0521cb2d60cfbb1a6"
  instance_type = "t3.micro"
  for_each = toset(var.env)
  tags = {
    Name = each.key
  }
}

#for_each resolve the problem to delete the instance based on key name which is in between a list