terraform {
  backend "s3" {
    bucket = "akankshaganta"
    key = "terraform/day-5/terraform.tfstate"
    dynamodb_table = "terraform-locks"
    encrypt = true
    # use_lockfile = true  #s3 native locking process to prevent concurrent state modifications
    region = "us-east-1"
  }
}