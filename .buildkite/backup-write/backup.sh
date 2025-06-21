#!/bin/bash

set -euo pipefail

echo "--- Getting Tailscale status"
tailscale --socket /var/run/tailscale/tailscaled.sock status --json

echo "--- Preparing runtime environment"
make -C deploy

echo "--- Backing up Writefreely instance"
make -C deploy/writefreely backup
