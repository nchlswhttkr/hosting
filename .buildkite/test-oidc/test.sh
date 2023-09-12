#!/bin/bash

set -euo pipefail

echo "--- Requesting token"
BUILDKITE_OIDC_JWT="$(buildkite-agent oidc request-token)"

echo "--- Logging in with token"
vault write -format=json auth/buildkite/login role=buildkite jwt="$BUILDKITE_OIDC_JWT" | tee login

jq -r ".token" login