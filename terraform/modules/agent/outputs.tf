output "public_ips" {
  value       = [for agent in hcloud_server.k3s-agents : agent.ipv4_address]
  description = "Public IPv4 addresses of the agent nodes"
}

output "private_ips" {
  value       = [for agent in hcloud_server.k3s-agents : (tolist(agent.network)[0].ip)]
  description = "Private IPv4 addresses of the agent nodes"
}

output "agent_info" {
  value = {
    for agent in hcloud_server.k3s-agents :
    agent.name => {
      public_ip  = agent.ipv4_address
      private_ip = tolist(agent.network)[0].ip
    }
  }
  description = "Information about the agent nodes"
}
