# A backend for Vault granting Terraform workloads access to AWS

resource "vault_aws_secret_backend" "aws" {
  access_key                = aws_iam_access_key.vault.id
  secret_key                = aws_iam_access_key.vault.secret
  region                    = "ap-southeast-4"
  default_lease_ttl_seconds = 60 * 60 # 1 hour
  max_lease_ttl_seconds     = 60 * 60 # 1 hour
}

resource "aws_iam_user" "vault" {
  name = "Vault"
}

resource "aws_iam_user_policy_attachment" "vault" {
  user       = aws_iam_user.vault.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  # TODO: Write a policy that only allows Vault to assume role
}

resource "aws_iam_access_key" "vault" {
  user = aws_iam_user.vault.name
}
