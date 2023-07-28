#!/bin/bash

set -euo pipefail

echo "--- Downloading backup artifact"
buildkite-agent artifact download "deploy/boyd/writefreely/backups/**/*.tar" .

echo "--- Uploading backup to S3"
export AWS_DEFAULT_REGION="ap-southeast-4"
BACKUP_BUCKET_NAME="$(aws ssm get-parameter --name "/backups/backups-bucket-name" | jq --raw-output ".Parameter.Value")"
aws s3 cp --recursive deploy/boyd/writefreely/backups/boyd/home/write/backups "s3://${BACKUP_BUCKET_NAME}/write/"
