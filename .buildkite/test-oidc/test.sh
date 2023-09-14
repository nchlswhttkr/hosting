#!/bin/bash

set -euo pipefail

TOKEN="$(buildkite-agent oidc request-token --audience sts.amazonaws.com)"

aws sts get-caller-identity --output json | tee identity

ACCOUNT_ID="$(jq -r ".Account" identity)"

aws sts assume-role-with-web-identity \
  --role-arn "arn:aws:iam::$ACCOUNT_ID:role/Buildkite" \
  --role-session-name "buildkite-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER" \
  --web-identity-token "$TOKEN"