resource "aws_s3_bucket" "bootstrap" {
  bucket = "elastic-buildkite-stack-bootstrap"
}

resource "aws_s3_object" "agent_bootstrap_script" {
  bucket  = aws_s3_bucket.bootstrap.bucket
  key     = "bootstrap.sh"
  content = <<-EOF
        #!/bin/bash
        set -euo pipefail

        sudo dnf -y update
        sudo dnf -y config-manager --add-repo https://pkgs.tailscale.com/stable/amazon-linux/2/tailscale.repo
        sudo dnf -y install tailscale
        sudo systemctl enable --now tailscaled
        sudo dnf -y config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
        sudo dnf -y install terraform vault

        TAILSCALE_AUTHENTICATION_KEY=$(aws ssm get-parameter --with-decryption --name "${aws_ssm_parameter.tailscale_authentication_key.name}" | jq --raw-output ".Parameter.Value")
        sudo tailscale up --authkey "$TAILSCALE_AUTHENTICATION_KEY" --hostname "buildkite"
    EOF
}

resource "aws_ssm_parameter" "tailscale_authentication_key" {
  name  = "/elastic-buildkite-stack/tailscale-authentication-key"
  type  = "SecureString"
  value = tailscale_tailnet_key.buildkite.key
}

resource "tailscale_tailnet_key" "buildkite" {
  ephemeral = true
  reusable  = true
  tags      = ["tag:buildkite"]

  # Since time_rotating marks itself as deleted, can't use replace_triggered_by https://github.com/hashicorp/terraform-provider-time/issues/118
  # Instead, include it in the description here to force recreation when rotation occurs
  description = "Buildkite Agents ${time_rotating.tailscale_rotation.unix}"
}

# Force rotation of authentication key if older than a few weeks
resource "time_rotating" "tailscale_rotation" {
  rotation_days = 21
}

resource "aws_s3_object" "agent_environment_file" {
  bucket  = aws_s3_bucket.bootstrap.bucket
  key     = "env"
  content = <<-EOF
        BUILDKITE_TRACING_PROPAGATE_TRACEPARENT=true
        OTEL_EXPORTER_OTLP_ENDPOINT="${data.vault_kv_secret_v2.honeycomb.data["endpoint"]}"
        OTEL_EXPORTER_OTLP_HEADERS="x-honeycomb-team=${data.vault_kv_secret_v2.honeycomb.data["ingest-api-key"]}"
    EOF
}

# TODO: Migrate to Honeycomb provider
data "vault_kv_secret_v2" "honeycomb" {
  mount = "kv"
  name  = "honeycomb-buildkite"
}
