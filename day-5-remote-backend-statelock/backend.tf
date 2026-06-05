terraform {
  backend "s3" {
    bucket = "akankshaganta"
    key = "terraform/day-5/terraform.tfstate"
    region = "us-east-1"
  }
}