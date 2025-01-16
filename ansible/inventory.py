#!/usr/bin/env python

import json
import subprocess
import os

# Define the relative path to the Terraform directory
terraform_dir = "../terraform/prod"

# Fetch Terraform output
terraform_output = subprocess.check_output(
    ["terraform", "output", "-json"], cwd=terraform_dir
).decode("utf-8")
terraform_data = json.loads(terraform_output)

# Extract server and agent details
server_info = terraform_data.get("server_info", {}).get("value", {})
agent_info = terraform_data.get("agent_info", {}).get("value", {})

# Ansible SSH configuration
ansible_ssh_user = "ansible"
ansible_ssh_private_key_file = os.path.join(os.path.dirname(__file__), ".ssh/ansible")

# Generate Ansible inventory
inventory = {
    "all": {
        "children": ["servers", "agents"],
        "vars": {
            "ansible_ssh_user": ansible_ssh_user,
            "ansible_ssh_private_key_file": ansible_ssh_private_key_file
        }
    },
    "servers": {
        "hosts": list(server_info.keys())
    },
    "agents": {
        "hosts": list(agent_info.keys())
    },
    "_meta": {
        "hostvars": {
            name: {
                "ansible_host": details["public_ip"],
                "public_ip": details["public_ip"],
                "private_ip": details["private_ip"]
            }
            for name, details in {**server_info, **agent_info}.items()
        }
    }
}

print(json.dumps(inventory, indent=2))
