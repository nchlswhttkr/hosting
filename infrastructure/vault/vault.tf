resource "vault_mount" "kv" {
  path = "kv"
  type = "kv-v2"
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_aws_secret_backend" "aws" {
  access_key                = aws_iam_access_key.vault.id
  secret_key                = aws_iam_access_key.vault.secret
  region                    = "ap-southeast-4"
  default_lease_ttl_seconds = 60 * 60 # 1 hour
  max_lease_ttl_seconds     = 60 * 60 # 1 hour
}

resource "vault_aws_secret_backend_role" "terraform" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "Terraform"
  credential_type = "assumed_role"
  role_arns = [
    aws_iam_role.vault_assumed_role.arn
  ]
}
