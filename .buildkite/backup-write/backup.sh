#!/bin/bash

set -euo pipefail

echo "--- Getting Tailscale status"
tailscale status --json

echo "--- Preparing runtime environment"
make -C deploy

echo "--- Backing up Writefreely instance"
make -C deploy/writefreely backup
