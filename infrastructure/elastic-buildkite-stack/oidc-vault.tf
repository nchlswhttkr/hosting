resource "vault_jwt_auth_backend" "buildkite" {
  path               = "buildkite"
  oidc_discovery_url = "https://agent.buildkite.com"

  tune {
    default_lease_ttl = "1h"
    max_lease_ttl     = "24h"
    token_type        = "service"
  }
}

resource "vault_jwt_auth_backend_role" "buildkite_agent" {
  backend        = vault_jwt_auth_backend.buildkite.path
  role_name      = "buildkite-agent"
  token_policies = ["default", vault_policy.buildkite_agent.name]
  role_type      = "jwt"
  user_claim     = "sub"

  bound_audiences = ["vault.nicholas.cloud"]
  bound_claims = {
    organization_slug = data.vault_kv_secret_v2.buildkite.data.organization
  }

  claim_mappings = {
    pipeline_slug = "pipeline_slug"
  }
}

resource "vault_policy" "buildkite_agent" {
  name   = "buildkite-agent"
  policy = <<-POLICY
    path "${vault_mount.buildkite.path}/data/{{identity.entity.aliases.${vault_jwt_auth_backend.buildkite.accessor}.metadata.pipeline_slug}}" {
      capabilities = ["read"]
    }

    path "${vault_mount.buildkite.path}/data/{{identity.entity.aliases.${vault_jwt_auth_backend.buildkite.accessor}.metadata.pipeline_slug}}/*" {
      capabilities = ["read"]
    }

    path "aws/sts/Terraform" {
      capabilities = ["read"]
    }

    # Needed by the AWS secret backend as it privisions its own child tokens
    path "auth/token/create" {
      capabilities = ["update"]
    }

    path "sys/storage/raft/snapshot" {
      capabilities = ["read"]
    }
  POLICY
}
