#!/usr/bin/env python
import json
import os
import requests
import sys

if "--list" not in sys.argv:
    print("{}")
    sys.exit(0)

# Retrieve Tailscale API token from Vault
vault_address = os.environ["VAULT_ADDR"]
vault_token = os.environ["VAULT_TOKEN"]
token = requests.get(
    f"{vault_address}/v1/kv/data/nchlswhttkr/tailscale",
    headers={"Authorization": f"Bearer {vault_token}"},
).json()["data"]["data"]["api_token"]

# Query tailnet for all devices
tailnet = "nchlswhttkr.github"
devices = requests.get(
    f"https://api.tailscale.com/api/v2/tailnet/{tailnet}/devices",
    headers={"Authorization": f"Bearer {token}"},
)

print(
    json.dumps(
        {
            "all": {
                "hosts": [
                    host["hostname"].lower() for host in devices.json()["devices"]
                ],
            },
            # https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html#tuning-the-external-inventory-script
            "_meta": {
                "hostvars": {
                    "gandra-dee": {
                        # TODO: Change ansible_user to be nchlswhttkr (default)
                        "ansible_user": "nicholas"
                    }
                }
            },
        }
    )
)
