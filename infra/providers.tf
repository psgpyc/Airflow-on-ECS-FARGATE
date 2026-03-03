terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }

  }


  backend "s3" {
    bucket  = "aede-terraform-state-40056b"
    key     = "dev/aede/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {

  # profile = var.aws_profile
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "AEDE"
      ManagedBy   = "terraform"
      Environment = "dev"
    }
  }

}