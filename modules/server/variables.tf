variable "server_count" {
  description = "Number of servers"
  type        = number
}

variable "network_id" {
  description = "Network ID for the servers"
  type        = string
}

variable "user_data_file" {
  description = "Path to the cloud-init file"
  type        = string
}
