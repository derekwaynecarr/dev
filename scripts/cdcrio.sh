# Usage:
# $ source cdcrio.sh
#
# To make this convenient, add to .bashrc:
# alias cdcscrio="source /PATH/TO/cdcrio.sh"
#

ulimit -S -n 4096
export GOROOT=$HOME/.gvm/gos/go1.8.1
export GOPATH=$HOME/go
cd "${GOPATH}/src/github.com/kubernetes-incubator/cri-o"