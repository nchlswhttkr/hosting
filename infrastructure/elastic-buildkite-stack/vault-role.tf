resource "vault_policy" "buildkite" {
  name = "buildkite"
  # https://registry.terraform.io/providers/hashicorp/vault/latest/docs#token
  # Note that the given token must have the update capability on the auth/token/create path in Vault in order to create child tokens.
  policy = <<-POLICY
    path "auth/token/create" {
      capabilities = ["update"]
    }
    
    path "kv/data/buildkite/{{identity.entity.aliases.${vault_jwt_auth_backend.buildkite.accessor}.metadata.pipeline_slug}}" {
      capabilities = ["read"]
    }

    path "aws/sts/Terraform" {
      capabilities = ["read"]
    }

    path "sys/storage/raft/snapshot" {
      capabilities = ["read"]
    }
  POLICY
}

resource "vault_jwt_auth_backend" "buildkite" {
  path               = "buildkite"
  oidc_discovery_url = "https://agent.buildkite.com"
}

resource "vault_jwt_auth_backend_role" "buildkite" {
  backend        = vault_jwt_auth_backend.buildkite.path
  role_name      = "buildkite"
  token_policies = ["default", vault_policy.buildkite.name]
  role_type      = "jwt"

  # TODO: What is this?
  user_claim = "sub"

  bound_claims = {
    organization_slug = local.buildkite_organization
  }

  claim_mappings = {
    pipeline_slug = "pipeline_slug"
  }
}
