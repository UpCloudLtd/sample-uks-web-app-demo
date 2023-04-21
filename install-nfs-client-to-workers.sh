#!/bin/bash
for IP in $(kubectl get nodes -o wide | awk '{print $7}'| grep -v EXTERNAL-IP )
do
   ssh $IP -o "StrictHostKeyChecking no" -l debian sudo apt-get -y install nfs-client nfs-common
done