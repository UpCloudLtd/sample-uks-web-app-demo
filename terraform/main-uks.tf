resource "upcloud_network" "uks-sdn-network" {
  name = "uks-cluster-network"
  zone = var.zone
  ip_network {
    address = var.uks_network
    dhcp    = true
    family  = "IPv4"
  }

  # UpCloud Kubernetes Service will add a router to this network to ensure cluster networking is working as intended.
  # You need to ignore changes to it, otherwise TF will attempt to detach the router on subsequent applies
  lifecycle {
    ignore_changes = [router]
  }
}

resource "upcloud_kubernetes_cluster" "web-application" {
  name    = "web-application-cluster"
  network = upcloud_network.uks-sdn-network.id
  zone    = var.zone
}

resource "upcloud_kubernetes_node_group" "group" {
  name          = "web-apps"
  cluster       = upcloud_kubernetes_cluster.web-application.id
  node_count    = var.worker_count
  plan          = var.worker_plan
  anti_affinity = true
  labels = {
    managedBy = "terraform"
  }
  // Each node in this group will have this key added to authorized keys (for "debian" user)
  ssh_keys = [
    var.ssh_key_public,
  ]
}


data "upcloud_kubernetes_cluster" "web-application" {
  id = upcloud_kubernetes_cluster.web-application.id
}

# With `hashicorp/local` Terraform provider one can output the kubeconfig to a file. The file can be easily
# used to configure `kubectl` or any other Kubernetes client.
resource "local_file" "kubeconfig" {
  content  = data.upcloud_kubernetes_cluster.web-application.kubeconfig
  filename = "${path.module}/kubeconfig.yml"
}
