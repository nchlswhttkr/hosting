resource "aws_ssm_parameter" "vault_secret_id" {
  name  = "/elastic-buildkite-stack/vault-secret-id/${vault_approle_auth_backend_role.buildkite.role_id}"
  type  = "SecureString"
  value = vault_approle_auth_backend_role_secret_id.buildkite.secret_id
}

resource "vault_policy" "buildkite" {
  name = "buildkite"
  # https://registry.terraform.io/providers/hashicorp/vault/latest/docs#token
  # Note that the given token must have the update capability on the auth/token/create path in Vault in order to create child tokens.
  policy = <<-POLICY
    path "auth/token/create" {
      capabilities = ["update"]
    }

    path "kv/data/buildkite/*" {
      capabilities = ["read"]
    }
    
    path "aws/sts/Terraform" {
      capabilities = ["read"]
    }
  POLICY
}

resource "vault_approle_auth_backend_role" "buildkite" {
  backend        = "approle"
  role_name      = "buildkite"
  token_policies = ["default", vault_policy.buildkite.name]
}

resource "vault_approle_auth_backend_role_secret_id" "buildkite" {
  role_name = vault_approle_auth_backend_role.buildkite.role_name
}
