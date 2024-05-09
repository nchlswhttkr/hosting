#!/bin/bash

set -euo pipefail

echo "--- Authenticating to AWS"
BUILDKITE_OIDC_TOKEN="$(buildkite-agent oidc request-token --audience sts.amazonaws.com)"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity | jq --raw-output ".Account")"

AWS_CREDENTIALS="$(
    aws sts assume-role-with-web-identity \
        --role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/Backups" \
        --role-session-name "buildkite-$BUILDKITE_PIPELINE_SLUG-$BUILDKITE_BUILD_NUMBER" \
        --web-identity-token "$BUILDKITE_OIDC_TOKEN"
)"

AWS_ACCESS_KEY_ID="$(echo "$AWS_CREDENTIALS" | jq --raw-output .Credentials.AccessKeyId)"
export AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY="$(echo "$AWS_CREDENTIALS" | jq --raw-output .Credentials.SecretAccessKey)"
export AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN="$(echo "$AWS_CREDENTIALS" | jq --raw-output .Credentials.SessionToken)"
export AWS_SESSION_TOKEN

echo "--- Downloading backup artifact"
buildkite-agent artifact download "deploy/gandra-dee/plausible/backups/**/*.tar" .

echo "--- Uploading backup to S3"
export AWS_REGION="ap-southeast-4"
BACKUP_BUCKET_NAME="$(aws ssm get-parameter --name "/backups/backups-bucket-name" | jq --raw-output ".Parameter.Value")"
aws s3 cp --recursive deploy/gandra-dee/plausible/backups/gandra-dee/home/plausible/backups "s3://${BACKUP_BUCKET_NAME}/plausible/"
