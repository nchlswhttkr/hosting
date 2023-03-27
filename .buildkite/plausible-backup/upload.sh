#!/bin/bash

set -euo pipefail

echo "--- Downloading backup artifact"
buildkite-agent artifact download "playbooks/backups/**/*.tar" .

echo "--- Uploading backup to S3"
sleep 30 # Pretty sure STS should not 
aws s3 cp --recursive playbooks/backups/gandra-dee/mnt/backups/analytics/ s3://nchlswhttkr/plausible/
