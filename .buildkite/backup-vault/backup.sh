#!/bin/bash

set -euo pipefail

echo "--- Taking snapshot of Vault storage"
vault operator raft snapshot save "vault-$(date "+%Y-%m-%dT%H:%M:%SZ").snap"

