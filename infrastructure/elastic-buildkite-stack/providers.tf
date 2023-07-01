terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.59"
    }

    buildkite = {
      source  = "buildkite/buildkite"
      version = "~> 0.19"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = "~> 0.4"
    }

    tls = {
      source  = "hashicorp/tls"
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
    key            = "elastic-buildkite-stack"
    region         = "ap-southeast-4"
  }
}

locals {
  aws_tags = {
    Project = "Elastic Buildkite Stack"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token      = data.vault_aws_access_credentials.creds.security_token
  default_tags {
    tags = local.aws_tags
  }
}

provider "aws" {
  alias      = "melbourne"
  region     = "ap-southeast-4"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token      = data.vault_aws_access_credentials.creds.security_token
  default_tags {
    tags = local.aws_tags
  }
}

data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = "Terraform"
  type    = "sts"
}

provider "pass" {
  store = "/Users/nchlswhttkr/Google Drive/.password-store"
}

provider "vault" {}

provider "buildkite" {
  api_token    = data.vault_kv_secret_v2.buildkite.data.api_token
  organization = "nchlswhttkr"
}

data "vault_kv_secret_v2" "buildkite" {
  mount = "kv"
  name  = "nchlswhttkr/buildkite"
}
