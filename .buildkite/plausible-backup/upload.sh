#!/bin/bash

set -euo pipefail

echo "--- Retrieving AWS credentials"
AWS_CREDENTIALS="$(vault read -format=json aws/sts/Terraform)"
AWS_ACCESS_KEY_ID="$(echo "$AWS_CREDENTIALS" | jq --raw-output .data.access_key)"
export AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY="$(echo "$AWS_CREDENTIALS" | jq --raw-output .data.secret_key)"
export AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN="$(echo "$AWS_CREDENTIALS" | jq --raw-output .data.security_token)"
export AWS_SESSION_TOKEN

echo "--- Downloading backup artifact"
buildkite-agent artifact download "playbooks/backups/**/*.tar" .

echo "--- Uploading backup to S3"
sleep 30 # Pretty sure STS should not 
aws s3 cp --recursive playbooks/backups/gandra-dee/mnt/backups/analytics/ s3://nchlswhttkr/plausible/
