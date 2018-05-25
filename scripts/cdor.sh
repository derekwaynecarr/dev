# Usage:
# $ source cdo.sh
#
# To make this convenient, add to .bashrc:
# alias cdo="source /PATH/TO/cdo.sh"
#
# Running `cdo` in a new shell will:
# 1. put you in the right directory
# 2. put `oc` on your path
# 3. make `oc` use the generated admin.kubeconfig
#
# If you start openshift in sudo mode, you'll need to make the admin dir readable by the oc user
# $ sudo chmod -R a+rwX openshift.local.config/

cd $GOPATH/src/github.com/openshift/origin/
ulimit -S -n 4096
source contrib/completions/bash/oc
source contrib/completions/bash/openshift
export GOROOT=$HOME/.gvm/gos/go1.9.1
export PATH="`pwd`/_output/local/bin/linux/amd64:$GOROOT/bin:$PATH"
export OS_ROOT="${GOPATH}/src/github.com/openshift/origin"
export GO_OUT="${OS_ROOT}/_output/local/bin/linux/amd64/"
export PATH="${GO_OUT}:${PATH}"

cd $GOPATH/src/github.com/openshift/release/cluster/test-deploy
export KUBECONFIG=gcp-dev/admin.kubeconfig