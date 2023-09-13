#!/bin/bash

set -euo pipefail

vault kv get kv/buildkite/$BUILDKITE_PIPELINE_SLUG
