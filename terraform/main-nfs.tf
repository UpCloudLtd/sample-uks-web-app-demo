
resource "upcloud_server" "nas" {
  count      = var.create_nas ? 1 : 0
  hostname   = "nfs-server"
  zone       = var.zone
  plan       = "4xCPU-8GB"
  firewall   = true
  metadata   = true
  depends_on = [upcloud_network.uks-sdn-network]

  template {
    storage = "Ubuntu Server 22.04 LTS (Jammy Jellyfish)"
  }
  network_interface {
    type = "public"
  }
  network_interface {
    type = "utility"
  }
  network_interface {
    type    = "private"
    network = upcloud_network.uks-sdn-network.id
  }
  login {
    user = "root"
    keys = [
      var.ssh_key_public,
    ]
    create_password   = false
    password_delivery = "email"
  }
  user_data = <<-EOT
#!/bin/bash
awk 'NR==16{print "            nameservers:\n                addresses: [94.237.127.9,  94.237.40.9]"}1' /etc/netplan/50-cloud-init.yaml > awk_out
cat awk_out > /etc/netplan/50-cloud-init.yaml
netplan apply
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y update
apt-get -o 'Dpkg::Options::=--force-confold' -q -y upgrade
apt-get -o 'Dpkg::Options::=--force-confold' -q -y install nfs-kernel-server
mkdir -p /data
echo '/data         ${var.uks_network}(rw,sync,no_subtree_check,no_root_squash)' >> /etc/exports
chown -R nobody:nogroup /data
exportfs -ar
EOT
}
output "nfs-server-ip" {
  value = var.create_nas ? upcloud_server.nas[0].network_interface[2].ip_address : ""
}