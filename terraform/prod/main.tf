module "network" {
  source       = "../modules/network"
  network_name = "k3s-cluster"
  ip_range     = "10.0.0.0/16"
  subnet_range = "10.0.1.0/24"
}

module "servers" {
  source         = "../modules/server"
  server_count   = var.server_count
  network_id     = module.network.network_id
  user_data_file = <<EOF
#cloud-config
users:
  - name: admin
    ssh-authorized-keys:
      - ${var.admin_public_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash

  - name: ansible
    ssh-authorized-keys:
      - ${var.ansible_public_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
EOF
  depends_on     = [module.network]
}

module "agents" {
  source         = "../modules/agent"
  agent_count    = var.agent_count
  network_id     = module.network.network_id
  user_data_file = <<EOF
#cloud-config
users:
  - name: admin
    ssh-authorized-keys:
      - ${var.admin_public_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash

  - name: ansible
    ssh-authorized-keys:
      - ${var.ansible_public_ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
EOF
  depends_on     = [module.servers]
}

