### WordPress with NFS

In this example we will setup and use a shared NFS storage and use it to persist the Wordpress data.

First, you might want to delete the previous WordPress deployment as this one uses the same MySQL database. You can do this with

```
kubectl delete -f manifests/wordpress/wordpress-deployment.yaml
kubectl delete -f manifests/wordpress/upcloud-csi-volume.yaml
```

To get started with NFS you need to deploy nfs-provisioner. You can do that with the commands below, but you need to first
create a NFS server with Terraform. You can do it so by adding the following line to `terraform/config.tfvars`:


```
create_nas = true
```

And then `make apply`.

Then proceed by configuring the NFS provisioner on Kubernetes. For this you will need the NFS server IP. Run `make output` and
get `<nfs-server-ip>` for the following commands:

```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --create-namespace \
  --namespace nfs-provisioner \
  --set nfs.server=<nfs-server-ip> \
  --set nfs.path=/data
```

Then you need to install an NFS client to worker nodes as they do not have it by default.
You can do this via SSH or with the provided bash script `bash scripts/install-nfs-client-to-workers.sh`

Then you can deploy WordPress that uses an NFS server as a persistent volume.

```
kubectl create  -f manifests/wordpress/wordpress-with-nfs.yaml
```

Once again you access the hostname under EXTERNAL-IP with browser to finish the WordPress install.

```
$ kubectl get services
NAME              TYPE           CLUSTER-IP       EXTERNAL-IP                                           PORT(S)         AGE
wordpress-nfs     LoadBalancer   10.129.156.204   lb-0a3fc4da7b7d4d1c8a99dbbdaea23d90-1.upcloudlb.com   80:31992/TCP    42m
```