terraform {
  required_version = ">= 1.8.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    buildkite = {
      source  = "buildkite/buildkite"
      version = "~> 0.19"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.10"
    }
  }

  backend "s3" {
    bucket         = "nchlswhttkr-terraform-backend"
    dynamodb_table = "nchlswhttkr-terraform-backend"
    key            = "backups"
    region         = "ap-southeast-4"
  }
}

provider "aws" {
  region     = "ap-southeast-4"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token      = data.vault_aws_access_credentials.creds.security_token
  default_tags {
    tags = {
      Project = "Backups"
    }
  }
}

provider "buildkite" {
  api_token    = data.vault_kv_secret_v2.buildkite.data.api_token
  organization = data.vault_kv_secret_v2.buildkite.data.organization
}

provider "vault" {}
