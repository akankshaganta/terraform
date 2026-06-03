terraform {
  backend "s3" {
    bucket = "akankshaganta"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}