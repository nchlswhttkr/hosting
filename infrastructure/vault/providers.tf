terraform {
  required_version = "~> 1.8"

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

  backend "local" {
    path = "/Users/nchlswhttkr/My Drive/nicholas.cloud/vault.tfstate"
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
