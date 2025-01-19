terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    # vault = {
    #   source  = "hashicorp/vault"
    #   version = "4.6.0"
    # }
  }
}


# resource "helm_release" "vault" {
#   name             = "vault"
#   repository       = "https://helm.releases.hashicorp.com"
#   chart            = "vault"
#   version          = "0.29.1"
#   namespace        = "vault"
#   create_namespace = true
# }

# resource "null_resource" "vault_init_store_secret" {
#   provisioner "local-exec" {
#     command = <<EOT
#       kubectl exec -n vault vault-0 -- vault operator init -format=json > /tmp/vault-init.json
#       kubectl create secret generic vault-unseal-keys \
#         --from-file=/tmp/vault-init.json \
#         -n vault
#       echo "Vault unseal keys stored in Kubernetes secret."
#     EOT
#   }

#   depends_on = [helm_release.vault]
# }

# resource "null_resource" "vault_unseal" {
#   provisioner "local-exec" {
#     command = <<EOT
#       echo "Fetching unseal keys from Kubernetes secret..."
#       kubectl get secret vault-unseal-keys -n vault -o jsonpath='{.data.vault-init\.json}' | base64 --decode > /tmp/vault-init.json
#       export VAULT_UNSEAL_KEY1=$(jq -r '.unseal_keys_b64[0]' /tmp/vault-init.json)
#       export VAULT_UNSEAL_KEY2=$(jq -r '.unseal_keys_b64[1]' /tmp/vault-init.json)
#       export VAULT_UNSEAL_KEY3=$(jq -r '.unseal_keys_b64[2]' /tmp/vault-init.json)
#       kubectl exec -n vault vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY1
#       kubectl exec -n vault vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY2
#       kubectl exec -n vault vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY3
#       echo "Vault unsealed."
#     EOT
#   }

#   depends_on = [null_resource.vault_init_store_secret]
# }


# resource "null_resource" "port_forward_vault" {
#   provisioner "local-exec" {
#     command = "nohup kubectl port-forward svc/vault 8200:8200 -n vault > /dev/null 2>&1 & echo $! > /tmp/vault-port-forward.pid"
#   }

#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   depends_on = [null_resource.vault_unseal]
# }

# resource "null_resource" "stop_port_forward" {
#   provisioner "local-exec" {
#     when    = destroy
#     command = "kill $(cat /tmp/vault-port-forward.pid) || true"
#   }
# }

# resource "kubernetes_service_account" "vault_auth" {
#   metadata {
#     name      = "vault-auth"
#     namespace = "vault"
#   }
#   automount_service_account_token = true
# }

# resource "kubernetes_cluster_role_binding" "vault_auth_binding" {
#   metadata {
#     name = "vault-auth-binding"
#     # namespace = "vault"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "system:auth-delegator"
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.vault_auth.metadata.0.name
#     namespace = kubernetes_service_account.vault_auth.metadata.0.namespace
#   }
# }

# resource "kubernetes_secret" "vault_auth_sa" {
#   metadata {
#     name      = kubernetes_service_account.vault_auth.metadata.0.name
#     namespace = kubernetes_service_account.vault_auth.metadata.0.namespace
#     annotations = {
#       "kubernetes.io/service-account.name" = kubernetes_service_account.vault_auth.metadata.0.name
#     }
#   }
#   type = "kubernetes.io/service-account-token"

#   wait_for_service_account_token = true
# }

# data "kubernetes_secret" "vault_auth_sa" {
#   metadata {
#     name      = kubernetes_service_account.vault_auth.metadata.0.name
#     namespace = kubernetes_service_account.vault_auth.metadata.0.namespace
#   }
# }

# resource "vault_auth_backend" "kubernetes" {
#   type = "kubernetes"
#   path = "kubernetes"
# }

# resource "vault_kubernetes_auth_backend_config" "k8s_auth_config" {
#   backend                = vault_auth_backend.kubernetes.path
#   kubernetes_host        = var.kubernetes_api_endpoint
#   kubernetes_ca_cert     = data.kubernetes_secret.vault_auth_sa.data["ca.crt"]
#   token_reviewer_jwt     = data.kubernetes_secret.vault_auth_sa.data["token"]
#   issuer                 = "api"
#   disable_iss_validation = true
# }

# resource "vault_policy" "k8s_secret_policy" {
#   name = "k8s-secret-policy"

#   policy = <<EOF
# path "secret/data/*" {
#   capabilities = ["read", "list", "create", "update", "delete"]
# }
# EOF
# }

# resource "vault_mount" "kv" {
#   path = "secret"
#   type = "kv"
#   options = {
#     version = "2"
#   }
#   description = "K/V v2 mount"
# }

# resource "vault_kv_secret_v2" "example" {
#   mount = "secret"
#   name  = "data"

#   data_json = jsonencode({
#     "username" = "admin"
#     "password" = "secret"
#   })

# }

resource "helm_release" "argo-cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.7.16"
  namespace        = "argo-cd"
  create_namespace = true
}

resource "helm_release" "app_of_apps" {
  name  = "app-of-apps"
  chart = "${path.module}/../../../k8s/"

  depends_on = [helm_release.argo-cd]
}
