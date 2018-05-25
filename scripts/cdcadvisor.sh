# Usage:
# $ source cdcadvsor.sh
#
# To make this convenient, add to .bashrc:
# alias cdcadvisor="source /PATH/TO/cdcadvsor.sh"
#

ulimit -S -n 4096
export GOROOT=$HOME/.gvm/gos/go1.8.1
export GOPATH=$HOME/go
cd "${GOPATH}/src/github.com/google/cadvisor"