output "public_server_ips" {
  value       = module.servers.public_ips
  description = "Public IP addresses of the server nodes"
}

output "public_agent_ips" {
  value       = module.agents.public_ips
  description = "Public IP addresses of the agent nodes"
}

output "private_server_ips" {
  value       = module.servers.private_ips
  description = "Private IP addresses of the server nodes"
}

output "private_agent_ips" {
  value       = module.agents.private_ips
  description = "Private IP addresses of the agent nodes"
}

output "server_info" {
  value       = module.servers.server_info
  description = "Information about the server nodes"
}

output "agent_info" {
  value       = module.agents.agent_info
  description = "Information about the agent nodes"
}
