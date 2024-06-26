terraform {
  required_version = "~> 1.8.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.13"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = "~> 0.1"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "nchlswhttkr-terraform-backend"
    dynamodb_table = "nchlswhttkr-terraform-backend"
    key            = "nicholas-dot-cloud-preview"
    region         = "ap-southeast-4"
  }
}

locals {
  aws_tags = {
    Project = "Website Preview"
  }
}

provider "aws" {
  region     = "ap-southeast-2"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token      = data.vault_aws_access_credentials.creds.security_token
  default_tags {
    tags = local.aws_tags
  }
}

provider "aws" {
  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html#https-requirements-certificate-issuer
  # To use an ACM certificate with CloudFront, make sure you request (or import) the certificate in the US East (N. Virginia) Region (us-east-1).

  alias      = "us_tirefire_1" # https://twitter.com/grepory/status/759204528382210049
  region     = "us-east-1"
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

provider "github" {
  token = data.pass_password.github_secret_token.password
}

data "pass_password" "github_secret_token" {
  name = "website/github-access-token"
}

provider "pass" {}
