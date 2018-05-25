#!/bin/bash

# This script automates deployment of a kubernetes federation control plane on
# a minikube instance.  It assumes the following has already been done.
# 
# Prereqs
# cd $HOME/go/src/k8s.io/kubernetes
# make WHAT=cmd/hyperkube,federation/cmd/kubefed
# export KUBECONFIG=.minikube-kubeconfig
# minikube start

# we want to use the binary we built on host when testing federation.
# minikube will mount your home directory into /hosthome
export HYPERKUBE_PATH="`pwd`/_output/local/go/bin/hyperkube"

# namespace of host cluster for federation control plane
export FEDERATION_NAMESPACE="${FEDERATION_NAMESPACE:-federation-system}"
# we must specify an image, but we will end up replacing the binary after the fact
export FEDERATION_IMAGE="gcr.io/google_containers/hyperkube-amd64:v1.6.4"
# the name of the federation
export FEDERATION_NAME="${FEDERATION_NAME:-federation}"
# the name for the member
export FEDERATION_MEMBER_NAME="${FEDERATION_MEMBER_NAME:-member0}"
# the host cluster context we deploy federation onto
export HOST_CLUSTER_CONTEXT=$(kubectl config current-context)
# the ip address we can advertise node port services against
export HOST_API_SERVER_ADDRESS=$(minikube ip)

# deploy the federation control plane
kubefed init "${FEDERATION_NAME}" \
--dns-provider=google-clouddns \
--etcd-persistent-storage=false \
--federation-system-namespace="${FEDERATION_NAMESPACE}" \
--host-cluster-context="${HOST_CLUSTER_CONTEXT}" \
--api-server-advertise-address="${HOST_API_SERVER_ADDRESS}" \
--api-server-service-type=NodePort \
--image="${FEDERATION_IMAGE}"

# fixup so we can work with local code
KC="kubectl --namespace=${FEDERATION_NAMESPACE}"
export CONTROLLER_MANAGER="${FEDERATION_NAME}-controller-manager"
export APISERVER="${FEDERATION_NAME}-apiserver"
export SERVICE_ACCOUNT="system:serviceaccount:${FEDERATION_NAMESPACE}:default"

# Scale the deployment down to avoid triggering an update after each patch
${KC} scale deploy "${APISERVER}" --replicas=0
${KC} scale deploy "${CONTROLLER_MANAGER}" --replicas=0

## Mount a local hyperkube binary if present
export HOST_HYPERKUBE_PATH=$(echo $HYPERKUBE_PATH | sed 's/home/hosthome/')  

# Update API server for volume from local built
${KC} patch deploy "${APISERVER}" --type=json -p='[{"op": "add", "path": "/spec/template/spec/volumes/-", "value": {"name": "hyperkube", "hostPath": {"path": "'"${HOST_HYPERKUBE_PATH}"'"}}}]'
${KC} patch deploy "${APISERVER}" --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/volumeMounts/-", "value": {"mountPath": "/hyperkube", "name": "hyperkube", "readOnly": true}}]'

# Update CONTROLLER_MANAGER server for volume from local built
${KC} patch deploy "${CONTROLLER_MANAGER}" --type=json -p='[{"op": "add", "path": "/spec/template/spec/volumes/-", "value": {"name": "hyperkube", "hostPath": {"path": "'"${HOST_HYPERKUBE_PATH}"'"}}}]'
${KC} patch deploy "${CONTROLLER_MANAGER}" --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/volumeMounts/-", "value": {"mountPath": "/hyperkube", "name": "hyperkube", "readOnly": true}}]'

# Disable the services controller to avoid a dependency on dnsaas
# TODO enable coredns when documentation is available
${KC} patch deploy "${CONTROLLER_MANAGER}" --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command/-", "value": "--controllers=services=false"}]'

# Scale the deployment back up
${KC} scale deploy "${APISERVER}" --replicas=1
${KC} scale deploy "${CONTROLLER_MANAGER}" --replicas=1

# wait for federation to be ready
FEDERATION_REPLICAS=$(${KC} get deployments "${APISERVER}" -o json | jq '.status.availableReplicas')
until [ "${FEDERATION_REPLICAS}" -ge "1" ]; do
  echo "Waiting for federation to be ready"
  sleep 5
  FEDERATION_REPLICAS=$(${KC} get deployments "${APISERVER}" -o json | jq '.status.availableReplicas')
done

## Join the host cluster to the federation
kubefed join ${FEDERATION_MEMBER_NAME} --context="${FEDERATION_NAME}" --host-cluster-context="${HOST_CLUSTER_CONTEXT}" --cluster-context="${HOST_CLUSTER_CONTEXT}"