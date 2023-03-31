#!/bin/bash

set -euo pipefail

GITHUB_ACCESS_TOKEN="$(vault kv get -mount kv -field access_token nchlswhttkr/github)"

# https://docs.github.com/en/rest/users/keys?apiVersion=2022-11-28#create-a-public-ssh-key-for-the-authenticated-user
curl --silent --fail --show-error --location \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/keys \
    -d "{\"title\":\"Buildkite agents on $(date -u "+%Y-%m-%d")\",\"key\":\"$SSH_PUBLIC_KEY\"}"
