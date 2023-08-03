
resource "vault_policy" "prometheus" {
  name   = "prometheus"
  policy = <<-POLICY
    path "/sys/metrics" {
      capabilities = ["read"]
    }
  POLICY
}

resource "vault_token" "prometheus" {
  policies = ["default", vault_policy.prometheus.name]
}

resource "vault_kv_secret_v2" "prometheus" {
  mount = vault_mount.kv.path
  name  = "hosting/vault-prometheus-metrics"
  data_json = jsonencode({
    vault_token = vault_token.prometheus.client_token
  })
}
