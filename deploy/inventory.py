#!/usr/bin/env python
import json
import platform
import subprocess
import sys

if "--list" not in sys.argv:
    print("{}")
    sys.exit(0)

TAILSCALE_BINARY = 'tailscale' if platform.system() != 'Darwin' else '/Applications/Tailscale.app/Contents/MacOS/Tailscale'
tailscale_status_process = subprocess.run([TAILSCALE_BINARY, 'status', '--json'], capture_output=True, check=True)
tailscale_status = json.loads(tailscale_status_process.stdout)
hosts = [peer["HostName"] for peer in tailscale_status["Peer"].values()]

print(
    json.dumps(
        {
            "all": {
                "hosts": hosts,
            },
            # https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html#tuning-the-external-inventory-script
            "_meta": {},
        }
    )
)
