variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {}
}

# variable "cidr_block" {
#   type = string
# }