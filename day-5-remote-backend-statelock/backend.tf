terraform {
  backend "s3" {
    bucket = "akankshaganta"
    key = "terraform/day-5/terraform.tfstate"
    use_lockfile = true  #s3 native locking process to prevent concurrent state modifications
    region = "us-east-1"
  }
}