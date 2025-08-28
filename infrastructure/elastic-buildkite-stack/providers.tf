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

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.13"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
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

provider "buildkite" {
  api_token    = data.vault_kv_secret_v2.buildkite.data["api-token"]
  organization = data.vault_kv_secret_v2.buildkite.data["organization"]
}

data "vault_kv_secret_v2" "buildkite" {
  mount = "kv"
  name  = "buildkite"
}

provider "github" {
  token = data.vault_kv_secret_v2.github.data["access-token"]
}

data "vault_kv_secret_v2" "github" {
  mount = "kv"
  name  = "github"
}

provider "tailscale" {
  oauth_client_id     = data.vault_kv_secret_v2.tailscale.data["client-id"]
  oauth_client_secret = data.vault_kv_secret_v2.tailscale.data["client-secret"]
}

data "vault_kv_secret_v2" "tailscale" {
  mount = "kv"
  name  = "tailscale"
}

provider "vault" {}
