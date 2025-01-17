terraform {
  required_version = ">= 1.3.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
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
