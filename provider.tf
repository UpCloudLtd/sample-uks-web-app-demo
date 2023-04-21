terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = ">= 2.9.0"
    }
  }
}

# Kubernetes provider configuration uses the data source
provider "kubernetes" {
  client_certificate     = data.upcloud_kubernetes_cluster.web-application.client_certificate
  client_key             = data.upcloud_kubernetes_cluster.web-application.client_key
  cluster_ca_certificate = data.upcloud_kubernetes_cluster.web-application.cluster_ca_certificate
  host                   = data.upcloud_kubernetes_cluster.web-application.host
}
