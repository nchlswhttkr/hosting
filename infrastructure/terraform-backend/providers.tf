terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = ">= 0.1"
    }
  }

  backend "local" {
    path = "/Users/nchlswhttkr/Google Drive/nicholas.cloud/terraform-backend.tfstate"
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

provider "pass" {
  store = "/Users/nchlswhttkr/Google Drive/.password-store"
}
