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
  }
}

resource "kubernetes_secret" "hcloud" {
  metadata {
    name      = "hcloud"
    namespace = "default"
  }

  data = {
    token = var.hcloud_token
  }

}

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

