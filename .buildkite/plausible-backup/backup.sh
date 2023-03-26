#!/bin/bash

set -euo pipefail

echo "--- Preparing runtime environment"
python3 -m venv .venv
make -C playbooks install

echo "--- Backing up Plausible instance"
make -C playbooks backup-plausible
