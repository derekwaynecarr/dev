# Usage:
# $ source cdbuildah.sh
#

cd $GOPATH/src/github.com/projectatomic/buildah
ulimit -S -n 4096
export GOROOT=$HOME/.gvm/gos/go1.9.1
export PATH="`pwd`/_output/local/bin/linux/amd64:$GOROOT/bin:$PATH"