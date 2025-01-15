terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

resource "hcloud_server" "k3s-servers" {
  count       = var.server_count
  name        = "k3s-server-${count.index}"
  image       = "ubuntu-24.04"
  server_type = "cx22"
  location    = "nbg1"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = var.network_id
    ip         = "10.0.1.${count.index + 1}"
  }

  user_data = var.user_data_file

}
