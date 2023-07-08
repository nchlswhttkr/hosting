#!/usr/bin/env python
import json
import os
import requests
import sys

if "--list" not in sys.argv:
    print("{}")
    sys.exit(0)

# Query tailnet for all devices
token = os.environ["TAILSCALE_API_TOKEN"]
tailnet = os.environ["TAILSCALE_TAILNET"]
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
            "_meta": {},
        }
    )
)
