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
export KUBECONFIG=.kubeconfig
export GOROOT=$HOME/.gvm/gos/go1.10.2
export GOPATH=$HOME/go

cd "${GOPATH}/src/k8s.io/kubernetes"
export PATH="`pwd`/third_party/etcd:`pwd`/_output/local/go/bin:$GOROOT/bin:$PATH"
export CERT_DIR=`pwd`/_output/certs

export KUBE_ENABLE_CLUSTER_DASHBOARD=true
export KUBE_ENABLE_CLUSTER_DNS=true
export ALLOW_PRIVILEGED=true

## ENABLE CRI-O
export CONTAINER_RUNTIME=remote
export CONTAINER_RUNTIME_ENDPOINT='unix:///var/run/crio/crio.sock --runtime-request-timeout=15m'
export CGROUP_DRIVER="systemd"

source <(kubectl completion bash) 2>/dev/null