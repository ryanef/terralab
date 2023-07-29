terraform {
  required_providers {
    aws= {

    }
  }
}

provider "aws" {
    region = var.AWS_REGION
    shared_credentials_files = [var.credentials_file]
    profile = var.aws_credentials_profile
}