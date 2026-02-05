resource "aws_s3_bucket" "bootstrap" {
  bucket = "elastic-buildkite-stack-bootstrap"
}

resource "aws_s3_object" "agent_bootstrap_script" {
  bucket  = aws_s3_bucket.bootstrap.bucket
  key     = local.bootstrap_script_name
  content = <<-EOF
        #!/bin/bash
        set -euo pipefail

        sudo dnf -y update
        sudo dnf -y config-manager --add-repo https://pkgs.tailscale.com/stable/amazon-linux/2/tailscale.repo
        sudo dnf -y install tailscale
        sudo systemctl enable --now tailscaled
        sudo dnf -y config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
        sudo dnf -y install terraform vault

        # TODO: Remove this once stack supports AWS CLI >2.32.0
        # https://github.com/buildkite/elastic-ci-stack-for-aws/blob/HEAD/packer/linux/base/scripts/versions.sh#L6
        curl -sSfL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.33.3.zip" -o "awscliv2.zip"
        unzip -qq awscliv2.zip
        sudo ./aws/install --update

        TAILSCALE_CLIENT_ID="$(aws ssm get-parameter --name "${aws_ssm_parameter.tailscale_client_id.name}" --query "Parameter.Value" --output "text")"
        AWS_IDENTITY_TOKEN="$(aws sts get-web-identity-token --audience "api.tailscale.com/$TAILSCALE_CLIENT_ID" --signing-algorithm "ES384" --query "WebIdentityToken" --output "text")"
        sudo tailscale up --client-id "$TAILSCALE_CLIENT_ID" --id-token "$AWS_IDENTITY_TOKEN" --hostname "buildkite" --advertise-tags "tag:buildkite"
    EOF
}

resource "aws_ssm_parameter" "tailscale_client_id" {
  name  = "/elastic-buildkite-stack/tailscale-client-id"
  type  = "String"
  value = tailscale_federated_identity.aws.id
}

resource "tailscale_federated_identity" "aws" {
  description = "Elastic Buildkite Stack"
  scopes      = ["auth_keys"]
  tags        = ["tag:auto"]
  issuer      = local.aws_outbound_identity_federation_issuer_url
  subject     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_cloudformation_stack.buildkite.outputs["InstanceRoleName"]}"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_object" "agent_environment_file" {
  bucket  = aws_s3_bucket.bootstrap.bucket
  key     = local.environment_file_name
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
