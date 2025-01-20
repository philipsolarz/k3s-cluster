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

resource "null_resource" "fetch_kubeconfig" {
  connection {
    host        = module.servers.public_ips[0]
    user        = "admin"
    private_key = file(var.admin_private_key_path)
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.admin_private_key_path} admin@${module.servers.public_ips[0]}:/etc/rancher/k3s/k3s.yaml ~/.kube/k3s.yaml"
  }

  depends_on = [module.agents]
}

resource "null_resource" "adjust_kubeconfig" {
  provisioner "local-exec" {
    command = "sed -i 's/127.0.0.1/${module.servers.public_ips[0]}/' ~/.kube/k3s.yaml"
  }

  depends_on = [null_resource.fetch_kubeconfig]
}

module "k8s" {
  source                  = "../modules/k8s"
  depends_on              = [null_resource.adjust_kubeconfig]
  kubernetes_api_endpoint = "https://${module.servers.public_ips[0]}:6443"
  hcloud_token            = var.hcloud_token
  # providers = {
  #   vault = vault
  # }
}
