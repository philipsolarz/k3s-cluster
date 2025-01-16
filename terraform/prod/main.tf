module "network" {
  source       = "../modules/network"
  network_name = "k3s-cluster"
  ip_range     = "10.0.0.0/16"
  subnet_range = "10.0.1.0/24"
}

module "servers" {
  source       = "../modules/server"
  server_count = var.server_count
  network_id   = module.network.network_id
  user_data_file = templatefile("${path.module}/cloud-config/server.yaml", {
    admin_public_ssh_key   = var.admin_public_ssh_key
    ansible_public_ssh_key = var.ansible_public_ssh_key
    k3s_token              = var.k3s_token
  })

  depends_on = [module.network]
}

module "agents" {
  source      = "../modules/agent"
  agent_count = var.agent_count
  network_id  = module.network.network_id
  user_data_file = templatefile("${path.module}/cloud-config/agent.yaml", {
    admin_public_ssh_key   = var.admin_public_ssh_key
    ansible_public_ssh_key = var.ansible_public_ssh_key
    k3s_token              = var.k3s_token
    k3s_primary_server_ip  = module.servers.private_ips[0]
  })
  depends_on = [module.servers]
}

