#!/bin/bash

set -euo pipefail

echo "--- Downloading backup artifact"
buildkite-agent artifact download "vault-*.snap" .

echo "--- Uploading backup to S3"
# TODO: Create a dedicated backups bucket instead of using my default
aws s3 cp vault-*.snap s3://nchlswhttkr/vault/
