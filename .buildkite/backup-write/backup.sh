#!/bin/bash

set -euo pipefail

echo "--- Preparing runtime environment"
make -C deploy

echo "--- Backing up Writefreely instance"
make -C deploy/writefreely backup

ls -la deploy/writefreely/backups/
