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
    export VAULT_ADDR="https://vault.nicholas.cloud"
  EOF
}
