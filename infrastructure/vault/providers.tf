terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.10"
    }
  }

  backend "s3" {
    bucket         = "nchlswhttkr-terraform-backend"
    dynamodb_table = "nchlswhttkr-terraform-backend"
    key            = "vault"
    region         = "ap-southeast-4"
  }
}

provider "aws" {
  region = "ap-southeast-4"
  default_tags {
    tags = {
      Project = "Vault"
    }
  }
}

provider "vault" {}
