resource "aws_s3_bucket" "bootstrap" {
  bucket = "elastic-buildkite-stack-bootstrap"
}

resource "aws_s3_object" "bootstrap_script" {
  bucket  = aws_s3_bucket.bootstrap.bucket
  key     = "bootstrap.sh"
  content = <<-EOF
        #!/bin/bash
        set -euo pipefail

        sudo yum update -y gnupg2
        sudo yum install -y yum-utils
        sudo yum-config-manager -y --add-repo https://pkgs.tailscale.com/stable/amazon-linux/2/tailscale.repo
        sudo yum install -y tailscale
        sudo systemctl enable --now tailscaled
        sudo yum-config-manager -y --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
        sudo yum -y install terraform vault

        TAILSCALE_AUTHENTICATION_KEY=$(aws ssm get-parameter --with-decryption --name "${aws_ssm_parameter.tailscale_authentication_key.name}" | jq --raw-output ".Parameter.Value")
        sudo tailscale up --authkey "$TAILSCALE_AUTHENTICATION_KEY" --hostname "buildkite"
    EOF
}

resource "aws_ssm_parameter" "tailscale_authentication_key" {
  name  = "/elastic-buildkite-stack/tailscale-authentication-token"
  type  = "SecureString"
  value = data.vault_kv_secret_v2.tailscale.data.authentication_token
}

data "vault_kv_secret_v2" "tailscale" {
  mount = "kv"
  name  = "nchlswhttkr/tailscale"
}

data "aws_kms_key" "ssm_default" {
  key_id = "alias/aws/ssm"
}
