resource "aws_ssm_parameter" "vault_role_id" {
  name  = "/elastic-buildkite-stack/vault-role-id"
  type  = "SecureString"
  value = vault_approle_auth_backend_role.buildkite.role_id
}

resource "aws_ssm_parameter" "vault_secret_id" {
  name  = "/elastic-buildkite-stack/vault-secret-id"
  type  = "SecureString"
  value = vault_approle_auth_backend_role_secret_id.buildkite.secret_id
}

resource "vault_policy" "buildkite" {
  name   = "buildkite"
  policy = <<-POLICY
    path "kv/data/buildkite/*" {
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
