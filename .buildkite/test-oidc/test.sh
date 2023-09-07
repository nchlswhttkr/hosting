#!/bin/bash

set -euo pipefail

echo "--- Requesting token"
buildkite-agent oidc request-token | tee jwt

echo "--- Logging in with token"
vault write auth/buildkite/login role=buildkite jwt=@jwt