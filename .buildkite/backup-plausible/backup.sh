#!/bin/bash

set -euo pipefail

echo "--- Preparing runtime environment"
python3 -m venv .venv
make -C deploy

echo "--- Backing up Plausible instance"
make -C deploy/gandra-dee backup-plausible
