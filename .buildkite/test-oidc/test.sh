#!/bin/bash

set -euo pipefail

buildkite-agent oidc request-token --audience sts.amazonaws.com
