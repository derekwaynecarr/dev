# Usage:
# $ source cdkfed.sh
#
# To make this convenient, add to .bashrc:
# alias cdkfed="source /PATH/TO/cdkfed.sh"
#

ulimit -S -n 4096
cd "${GOPATH}/src/k8s.io/kubernetes"

export KUBECONFIG=.minikube-kubeconfig

export GOROOT=$HOME/.gvm/gos/go1.8.1
export GOPATH=$HOME/go
export PATH="`pwd`/third_party/etcd:`pwd`/_output/local/go/bin:$GOROOT/bin:$PATH"
export CERT_DIR=`pwd`/_output/certs

source <(kubectl completion bash) 2>/dev/null