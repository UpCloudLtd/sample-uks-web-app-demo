#### Monitoring example

You might want to deploy monitoring to see how cluster resources are used during testing.
We can use the kube-prometheus project for fast and easy deployment for testing.

First clone the kube-prometheus project from Github.

```
git clone https://github.com/prometheus-operator/kube-prometheus.git
```

And then deploy it to the UKS cluster.

```
kubectl apply --server-side -f kube-prometheus/manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f kube-prometheus/manifests/
```

The kube-prometheus project includes multiple components, but for now we want to just access Grafana dashboards.
For testing purposes, the easy way to access Grafana is to use port-forwarding from your local computer localhost.

```
 kubectl --namespace monitoring port-forward svc/grafana 3000
```

Then access via [http://localhost:3000](http://localhost:3000) and use the default grafana user:password of `admin:admin`.

Kube-prometheus was deployed to the namespace <i>"monitoring"</i>, so you need to use `-n monitoring` parameter when viewing objects in the <i>monitoring</i> namespace. For example:

```
kubectl get svc -n monitoring
NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
alertmanager-main       ClusterIP   10.138.206.96    <none>        9093/TCP,8080/TCP            47m
alertmanager-operated   ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   46m
blackbox-exporter       ClusterIP   10.128.106.240   <none>        9115/TCP,19115/TCP           47m
grafana                 ClusterIP   10.129.214.97    <none>        3000/TCP                     47m
kube-state-metrics      ClusterIP   None             <none>        8443/TCP,9443/TCP            47m
node-exporter           ClusterIP   None             <none>        9100/TCP                     47m
prometheus-adapter      ClusterIP   10.131.13.100    <none>        443/TCP                      47m
prometheus-k8s          ClusterIP   10.138.100.82    <none>        9090/TCP,8080/TCP            47m
prometheus-operated     ClusterIP   None             <none>        9090/TCP                     46m
prometheus-operator     ClusterIP   None             <none>        8443/TCP                     47m
```