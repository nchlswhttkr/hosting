terraform {
  required_version = "~> 1.8"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }

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

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = "~> 0.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.13"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.10"
    }
  }

  backend "s3" {
    bucket         = "nchlswhttkr-terraform-backend"
    dynamodb_table = "nchlswhttkr-terraform-backend"
    key            = "nicholas-dot-cloud"
    region         = "ap-southeast-4"
  }
}

provider "cloudflare" {
  api_token = data.pass_password.cloudflare_api_token.password
}

data "pass_password" "cloudflare_api_token" {
  name = "hosting/cloudflare-dns-api-token"
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

provider "pass" {}

provider "tailscale" {
  oauth_client_id     = data.vault_kv_secret_v2.tailscale.data.client_id
  oauth_client_secret = data.vault_kv_secret_v2.tailscale.data.client_secret
}

data "vault_kv_secret_v2" "tailscale" {
  mount = "kv"
  name  = "nchlswhttkr/tailscale"
}

provider "vault" {}
