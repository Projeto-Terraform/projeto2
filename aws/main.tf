terraform {
  required_version = ">=1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }

  backend "s3" {
    bucket = "projeto-terraform2112"
    key    = "aws-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner      = "projeto-terraform"
      managed-by = "terraform"
    }
  }
}