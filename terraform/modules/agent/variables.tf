variable "agent_count" {
  description = "Number of agents"
  type        = number
}

variable "network_id" {
  description = "Network ID for the agents"
  type        = string
}

variable "user_data_file" {
  description = "Path to the cloud-config file"
  type        = string
}
