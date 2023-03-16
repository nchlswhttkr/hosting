output "vault_role_id" {
  description = "The ID of the Vault role for Buildkite agents to use"
  value       = vault_approle_auth_backend_role.buildkite.role_id
}
