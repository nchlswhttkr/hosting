#!/usr/bin/env python
import collections
import json
import platform
import subprocess
import sys

if "--list" not in sys.argv:
    print("{}")
    sys.exit(0)

TAILSCALE_BINARY = (
    "tailscale"
    if platform.system() != "Darwin"
    else "/Applications/Tailscale.app/Contents/MacOS/Tailscale"
)
tailscale_status_process = subprocess.run(
    [TAILSCALE_BINARY, "status", "--json"], capture_output=True, check=True
)
tailscale_status = json.loads(tailscale_status_process.stdout)

inventory = collections.defaultdict(lambda: {"hosts": []})

for peer in tailscale_status["Peer"].values():
    if "Tags" in peer:
        for tag in peer["Tags"]:
            inventory[tag[4:].replace("-", "_")]["hosts"].append(peer["DNSName"])

# https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html#tuning-the-external-inventory-script
inventory["_meta"] = {}

print(json.dumps(inventory))
