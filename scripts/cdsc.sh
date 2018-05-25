# Usage:
# $ source cdsc.sh
#
# To make this convenient, add to .bashrc:
# alias cdsc="source /PATH/TO/cdsc.sh"
#
# Running `cdsc` in a new shell will:
# 1. put you in the right directory
# 2. put `kubectl` on your path from kube
#

ulimit -S -n 4096
cd "${GOPATH}/src/github.com/kubernetes-incubator/service-catalog"

export KUBEPATH="${GOPATH}/src/k8s.io/kubernetes"
export KUBECONFIG="${KUBEPATH}/.kubeconfig"
export GOROOT=$HOME/.gvm/gos/go1.8.1
export GOPATH=$HOME/go
export PATH="$KUBEPATH/third_party/etcd:$KUBEPATH/_output/local/go/bin:$HOME/.gvm/gos/go1.8.1/bin:$PATH"
export NO_DOCKER=1

echo "apiVersion: v1
clusters:
- cluster:
    server: http://127.0.0.1:30000
  name: service-catalog-cluster
contexts:
- context:
    cluster: service-catalog-cluster
    user: ""
  name: service-catalog
current-context: service-catalog
kind: Config
preferences: {}
users: []" > .servicecatalogconfig
export SERVICECATALOGCONFIG=.servicecatalogconfig

export HELM_ROOT="${GOPATH}/src/k8s.io/helm"
export HELM_OUT="${HELM_ROOT}/bin"
export PATH="${HELM_OUT}:${PATH}"

source <(kubectl completion bash) 2>/dev/null