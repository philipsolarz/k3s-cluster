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

# provider "vault" {
#   address = "http://127.0.0.1:8200"

#   auth_login {
#     path   = "kubernetes/login"
#     method = "kubernetes"
#   }
# }

