#!/bin/bash

set -euo pipefail

vault token lookup

vault kv get kv/buildkite/$BUILDKITE_PIPELINE_SLUG
