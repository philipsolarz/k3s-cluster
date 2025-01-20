variable "kubernetes_api_endpoint" {
  description = "The public API endpoint of the Kubernetes cluster"
  type        = string
}

variable "hcloud_token" {
  description = "The Hetzner Cloud API token"
  type        = string
}
