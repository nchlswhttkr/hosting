terraform {
  required_version = "~> 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }

    buildkite = {
      source  = "buildkite/buildkite"
      version = "~> 1.29"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.26.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.6"
    }
  }

  backend "s3" {
    bucket         = "nchlswhttkr-terraform-backend"
    dynamodb_table = "nchlswhttkr-terraform-backend"
    key            = "elastic-buildkite-stack"
    region         = "ap-southeast-4"
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
  api_token    = ephemeral.vault_kv_secret_v2.buildkite.data["api-token"]
  organization = local.buildkite_organization
}

ephemeral "vault_kv_secret_v2" "buildkite" {
  mount = "kv"
  name  = "buildkite"
}

provider "github" {
  token = ephemeral.vault_kv_secret_v2.github.data["access-token"]
}

ephemeral "vault_kv_secret_v2" "github" {
  mount = "kv"
  name  = "github"
}

provider "tailscale" {
  oauth_client_id     = ephemeral.vault_kv_secret_v2.tailscale.data["client-id"]
  oauth_client_secret = ephemeral.vault_kv_secret_v2.tailscale.data["client-secret"]
}

ephemeral "vault_kv_secret_v2" "tailscale" {
  mount = "kv"
  name  = "tailscale"
}

provider "vault" {}
