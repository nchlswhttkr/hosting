data "aws_caller_identity" "current" {}

data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = "Terraform"
  type    = "sts"
}

data "vault_kv_secret_v2" "buildkite" {
  mount = "kv"
  name  = "hosting/buildkite"
}

data "aws_ssm_parameter" "buildkite_oidc_provider_arn" {
  name = "/elastic-buildkite-stack/buildkite-oidc-provider-arn"
}
