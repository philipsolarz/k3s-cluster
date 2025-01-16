variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "admin_public_ssh_key" {
  description = "Admin public SSH Key"
  type        = string
}

variable "admin_private_key_path" {
  description = "Admin private SSH Key Path"
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

variable "k3s_token" {
  description = "K3s Token"
  type        = string
  default     = "changeme"
}
