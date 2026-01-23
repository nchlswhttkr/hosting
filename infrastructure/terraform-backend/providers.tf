terraform {
  required_version = "~> 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = ">= 0.1"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.10"
    }
  }

  backend "local" {
    path = "/Users/nchlswhttkr/My Drive/nicholas.cloud/terraform-backend.tfstate"
  }
}

provider "aws" {
  region = "ap-southeast-4"
  default_tags {
    tags = {
      Project = "Terraform Backend"
    }
  }
}

provider "pass" {}
