module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.14.0"
  bucket = "akankshaganta"
  region = "us-east-1"
  versioning = {
    enabled = true
  }
}