#!/bin/bash
#!/usr/bin/env bash

# this script provisions service catalog on a local cluster.
# where is your service-catalog source code
SERVICE_CATALOG_SOURCE="/home/decarr/go/src/github.com/kubernetes-incubator/service-catalog"
# What storage format should be used for service catalog, etcd or tpr
API_SERVER_STORAGE_TYPE="etcd"
# provision helm in cluster
helm init
# wait for tiller pod to be ready
TILLER_REPLICAS=$(kubectl get deployments tiller-deploy --namespace=kube-system -o json | jq '.status.availableReplicas')
until [ "${TILLER_REPLICAS}" -ge "1" ]; do
  echo "Waiting for tiller pod to be ready"
  sleep 5
  TILLER_REPLICAS=$(kubectl get deployments tiller-deploy --namespace=kube-system -o json | jq '.status.availableReplicas')
done
# tiller is ready
echo "tiller is ready"
helm install $SERVICE_CATALOG_SOURCE/charts/ups-broker --name ups-broker --namespace ups-broker
helm install --namespace=service-catalog --set apiserver.storage.type=${API_SERVER_STORAGE_TYPE},apiserver.insecure=true,apiserver.service.type=NodePort,apiserver.service.nodePort.insecurePort=30000,apiserver.image=apiserver:canary,apiserver.imagePullPolicy=Never,controllerManager.image=controller-manager:canary,controllerManager.imagePullPolicy=Never $SERVICE_CATALOG_SOURCE/charts/catalog -n sc
echo "done"