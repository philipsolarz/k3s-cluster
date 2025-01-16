variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "admin_public_ssh_key" {
  description = "Admin public SSH Key"
  type        = string
}

variable "ansible_public_ssh_key" {
  description = "Ansible public SSH Key"
  type        = string
}

variable "server_count" {
  description = "Number of servers in the cluster"
  type        = number
  default     = 1
}

variable "agent_count" {
  description = "Number of agents in the cluster"
  type        = number
  default     = 1
}
