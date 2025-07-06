resource "vault_mount" "buildkite" {
  path = "buildkite"
  type = "kv-v2"
}
