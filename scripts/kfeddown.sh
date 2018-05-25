#!/bin/bash

# This script automates teardown of a kubernetes federation control plane on
# a minikube instance started with kfedup.

# namespace of host cluster for federation control plane
export FEDERATION_NAMESPACE="${FEDERATION_NAMESPACE:-federation-system}"
# the name of the federation
export FEDERATION_NAME="${FEDERATION_NAME:-federation}"
# the name for the member
export FEDERATION_MEMBER_NAME="${FEDERATION_MEMBER_NAME:-member0}"
# the name of the controller manager
export CONTROLLER_MANAGER="${FEDERATION_NAME}-controller-manager"
# the name of the apiserver
export APISERVER="${FEDERATION_NAME}-apiserver"

echo "teardown started"

# delete the federation namespace on the host cluster
kubectl delete ns $FEDERATION_NAMESPACE
# delete the clusterrole for the federation
kubectl delete clusterrole "${CONTROLLER_MANAGER}:federation-${FEDERATION_MEMBER_NAME}-minikube"
# delete the clusterrolebinding for the federation
kubectl delete clusterrolebinding "${CONTROLLER_MANAGER}:federation-${FEDERATION_MEMBER_NAME}-minikube"

echo "done"
