terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}


resource "hcloud_network" "private_network" {
  name     = var.network_name
  ip_range = var.ip_range
}

resource "hcloud_network_subnet" "private_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.private_network.id
  network_zone = "eu-central"
  ip_range     = var.subnet_range
}

output "network_id" {
  value = hcloud_network.private_network.id
}
