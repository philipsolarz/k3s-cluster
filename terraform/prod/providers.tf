provider "hcloud" {
  token = var.hcloud_token
}

provider "kubernetes" {
  config_path = "~/.kube/k3s.yaml"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/k3s.yaml"
  }
}
