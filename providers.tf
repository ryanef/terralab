terraform {
  required_providers {
    aws= {

    }
  }
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_files = [var.credentials_file]
    profile = var.aws_credentials_profile
}