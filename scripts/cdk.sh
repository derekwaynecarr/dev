# Usage:
# $ source cdk.sh
#
# To make this convenient, add to .bashrc:
# alias cdk="source /PATH/TO/cdk.sh"
#
# Running `cdk` in a new shell will:
# 1. put you in the right directory
# 2. put `etcd2` on your path
#

ulimit -S -n 4096

export GOROOT=$HOME/.gvm/gos/go1.10.2
export GOPATH=$HOME/go

cd "${GOPATH}/src/k8s.io/kubernetes"
export PATH="`pwd`/third_party/etcd:`pwd`/_output/local/go/bin:$GOROOT/bin:$PATH"
export CERT_DIR=`pwd`/_output/certs
export KUBECONFIG=`pwd`/.kubeconfig

export KUBE_ENABLE_CLUSTER_DASHBOARD=true
export KUBE_ENABLE_CLUSTER_DNS=true
export ALLOW_PRIVILEGED=true

export KUBE_GCE_INSTANCE_PREFIX=decarr-e2e
export KUBE_GCE_NETWORK=decarr-e2e
export KUBERNETES_PROVIDER=local

export KUBE_REGISTRY=derekwaynecarr
export KUBE_VERSION=1.7.0-dev

echo "apiVersion: v1
clusters:
- cluster:
    server: http://127.0.0.1:8080
  name: local
contexts:
- context:
    cluster: local
    user: ""
  name: local
current-context: local
kind: Config
preferences: {}
users: []" > $KUBECONFIG

source <(kubectl completion bash) 2>/dev/null