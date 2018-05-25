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
export GOROOT=$HOME/.gvm/gos/go1.9.1
export GOPATH=$HOME/go

cd "${GOPATH}/src/github.com/kubernetes-incubator/cri-tools"
export PATH="`pwd`/_output/local/go/bin:$GOROOT/bin:$PATH"

## ENABLE CRI-O
export CONTAINER_RUNTIME=remote
export CRI_RUNTIME_ENDPOINT='/var/run/crio/crio.sock'
export CGROUP_DRIVER="systemd"

source <(kubectl completion bash) 2>/dev/null