# dev/backend.tf

terraform {
  backend "s3" {
    bucket         = "deep-researcher-tfstate-uat" # Must be unique in this AWS account
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "deep-researcher-tflocks-uat" # Used to prevent simultaneous runs
  }
}
