resource "aws_s3_object" "bandcamp_mini_embed_environment" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "bandcamp-mini-embed/environment"
  server_side_encryption = "aws:kms"
  content                = <<-EOF
    #!/bin/bash
    set -euo pipefail
    if [[ "$BUILDKITE_STEP_KEY" =~ "deploy" ]]; then
      export CLOUDFLARE_ACCOUNT_ID="$(vault kv get -mount=kv -field cloudflare_account_id buildkite/bandcamp-mini-embed)"
      export CLOUDFLARE_API_TOKEN="$(vault kv get -mount=kv -field cloudflare_api_token buildkite/bandcamp-mini-embed)"
    fi
  EOF
}

resource "aws_s3_object" "agent_environment" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "environment"
  server_side_encryption = "aws:kms"
  content                = <<-EOF
    #!/bin/bash
    set -euo pipefail

    export BUILDKITE_GIT_FETCH_FLAGS="-v --prune --tags"

    if [[ "$${VAULT_ROLE_ID:-}" != "" ]]; then
      VAULT_SECRET_ID="$(aws ssm get-parameter --with-decryption --name "/elastic-buildkite-stack/vault-secret-id/$VAULT_ROLE_ID" | jq --raw-output ".Parameter.Value")"
      VAULT_ADDR="https://vault.nicholas.cloud"
      export VAULT_ADDR
      VAULT_TOKEN="$(vault write -field=token auth/approle/login role_id="$VAULT_ROLE_ID" secret_id="$VAULT_SECRET_ID")"
      export VAULT_TOKEN
      unset VAULT_SECRET_ID
    fi

    if [[ "$${VAULT_ASSUME_AWS_ROLE:-}" != "" ]]; then
      AWS_CREDENTIALS="$(vault read -format=json "aws/sts/$VAULT_ASSUME_AWS_ROLE")"
      AWS_ACCESS_KEY_ID="$(echo "$AWS_CREDENTIALS" | jq --raw-output .data.access_key)"
      export AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY="$(echo "$AWS_CREDENTIALS" | jq --raw-output .data.secret_key)"
      export AWS_SECRET_ACCESS_KEY
      AWS_SESSION_TOKEN="$(echo "$AWS_CREDENTIALS" | jq --raw-output .data.security_token)"
      export AWS_SESSION_TOKEN
      unset AWS_CREDENTIALS
    fi
  EOF
}
