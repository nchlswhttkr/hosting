#!/bin/bash

set -euo pipefail

echo "--- Requesting token"
buildkite-agent oidc request-token | tee jwt

echo "--- Logging in with token"
curl --silent --fail --show-error --request POST "$VAULT_ADDR/v1/auth/buildkite/login" \
    --data "{
        \"role\": \"buildkite\",
        \"jwt\": \"$(cat jwt)\"
    }"
