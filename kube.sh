#!/bin/bash

if [ "$1" = "create" ]; then
  echo -e "Starting Kaa services...\n"
elif [ "$1" = "delete" ]; then
  echo -e "Stopping Kaa services...\n"
elif [ -z "$1" ]; then
  echo "Error. Expecting the one of the following actions: create, delete"
  exit 1
else
  echo "Error. Unknown action $1"
  exit 1
fi

kubectl $1 -f kubernetes/kube-nats.yml

kubectl $1 -f kubernetes/kube-scr.yml
kubectl $1 -f kubernetes/kube-kpc.yml
kubectl $1 -f kubernetes/kube-cm.yml
kubectl $1 -f kubernetes/kube-epr.yml
kubectl $1 -f kubernetes/kube-epmx.yml
kubectl $1 -f kubernetes/kube-epl.yml
kubectl $1 -f kubernetes/kube-wd.yml
kubectl $1 -f kubernetes/kube-epts.yml
kubectl $1 -f kubernetes/kube-dcx.yml
kubectl $1 -f kubernetes/kube-wsts.yml
#kubectl $1 -f kubernetes/kube-cmx.yml
#kubectl $1 -f kubernetes/kube-ecr.yml


echo -e '\nPods list:'
echo "$(kubectl get pods)"
