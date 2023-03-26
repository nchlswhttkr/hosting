#!/bin/bash

set -euo pipefail

python3 -m venv .venv
make -C playbooks install
make -C playbooks backup-plausible
