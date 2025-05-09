#!/bin/bash

set -euo pipefail

echo "--- Preparing runtime environment"
python3 -m venv .venv
make -C deploy

echo "--- Backing up Writefreely instance"
make -C deploy/writefreely backup
