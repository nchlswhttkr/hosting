terraform {
  required_version = ">= 1.8.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }

    buildkite = {
      source  = "buildkite/buildkite"
      version = "~> 1.29"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.6"
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
    tags = local.aws_tags
  }
}

provider "buildkite" {
  api_token    = ephemeral.vault_kv_secret_v2.buildkite.data["api-token"]
  organization = local.buildkite_organization
}

provider "vault" {}
