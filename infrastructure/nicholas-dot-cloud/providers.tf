terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.10"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.13"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = "~> 0.1"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.13"
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

  required_version = "~> 1.2"

  backend "s3" {
    bucket         = "nchlswhttkr-terraform-backend"
    dynamodb_table = "nchlswhttkr-terraform-backend"
    key            = "nicholas-dot-cloud"
    region         = "ap-southeast-4"
  }
}

provider "digitalocean" {
  token = data.pass_password.do_secret_token.password
}

data "pass_password" "do_secret_token" {
  name = "website/digitalocean-api-token"
}

provider "github" {
  token = data.pass_password.github_secret_token.password
}

data "pass_password" "github_secret_token" {
  name = "website/github-access-token"
}

provider "pass" {
  store = "/Users/nchlswhttkr/Google Drive/.password-store"
}

provider "tailscale" {
  api_key = data.vault_kv_secret_v2.tailscale.data.api_token
}

data "vault_kv_secret_v2" "tailscale" {
  mount = "kv"
  name  = "nchlswhttkr/tailscale"
}

provider "vault" {}
