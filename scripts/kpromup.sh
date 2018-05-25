#!/bin/bash
#!/usr/bin/env bash

# This script adds prometheus to a Kubernetes cluster.

# provision helm in cluster
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller

# wait for tiller pod to be ready
TILLER_REPLICAS=$(kubectl get deployments tiller-deploy --namespace=kube-system -o json | jq '.status.availableReplicas')
until [ "${TILLER_REPLICAS}" -ge "1" ]; do
  echo "Waiting for tiller pod to be ready"
  sleep 5
  TILLER_REPLICAS=$(kubectl get deployments tiller-deploy --namespace=kube-system -o json | jq '.status.availableReplicas')
done

# tiller is ready
echo "tiller is ready"

helm install --namespace=kube-system stable/prometheus --name monitoring -f prometheus-values.yaml

echo "done"