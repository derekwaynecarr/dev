# Usage:
# $ source cdsc.sh
#
# To make this convenient, add to .bashrc:
# alias cdcc="source /PATH/TO/cdcc.sh"
#
# Running `cdcc` in a new shell will:
# 1. put you in the right directory
# 2. put `kubectl` on your path from kube
#

ulimit -S -n 4096
cd "${GOPATH}/src/github.com/kubernetes-incubator/cluster-capacity"

export KUBEPATH="${GOPATH}/src/k8s.io/kubernetes"
export KUBECONFIG="${KUBEPATH}/.kubeconfig"
export GOROOT=$HOME/.gvm/gos/go1.8.1
export GOPATH=$HOME/go
export PATH="$KUBEPATH/_output/local/go/bin:$GOROOT/bin:$PATH"
export NO_DOCKER=1

source <(kubectl completion bash) 2>/dev/null