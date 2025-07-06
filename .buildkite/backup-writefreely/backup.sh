#!/bin/bash

set -euo pipefail

echo "--- Preparing runtime environment"
make -C deploy

echo "--- Backing up Writefreely instance"
make -C deploy/writefreely backup

echo "--- Uploading backups as build artifacts"
# Ansible syncing files breaks subsequent builds, upload directly and purge now
buildkite-agent artifact upload "deploy/writefreely/backups/*.tar"
rm -r deploy/writefreely/backups
