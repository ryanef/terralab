terraform {
  required_providers {
    aws= {

    }
  }
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_files = ["/var/lib/jenkins/credentials", "~/.aws/credentials"]
}