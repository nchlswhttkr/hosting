#!/bin/bash

set -euo pipefail

GITHUB_ACCESS_TOKEN="$(vault kv get -mount kv -field access_token nchlswhttkr/github)"

# https://docs.github.com/en/rest/users/keys?apiVersion=2022-11-28#list-public-ssh-keys-for-the-authenticated-user
SSH_KEY_ID="$(
    curl --silent --fail --show-error --location \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN"\
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/user/keys \
        | jq --raw-output ".[] | select(.key == \"$SSH_PUBLIC_KEY\") | .id"
)"

if [[ "$SSH_KEY_ID" == "" ]]; then
    exit 0
fi

# https://docs.github.com/en/rest/users/keys?apiVersion=2022-11-28#delete-a-public-ssh-key-for-the-authenticated-user
curl --silent --fail --show-error --location \
    -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/user/keys/$SSH_KEY_ID"