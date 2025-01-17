output "public_ips" {
  value       = [for server in hcloud_server.k3s-servers : server.ipv4_address]
  description = "Public IPv4 addresses of the server nodes"
}

output "private_ips" {
  value       = [for server in hcloud_server.k3s-servers : (tolist(server.network)[0].ip)]
  description = "Private IPv4 addresses of the server nodes"
}

output "server_info" {
  value = {
    for server in hcloud_server.k3s-servers :
    server.name => {
      public_ip  = server.ipv4_address
      private_ip = tolist(server.network)[0].ip
    }
  }
  description = "Information about the server nodes"
}
