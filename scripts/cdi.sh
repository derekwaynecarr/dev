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

cd $GOPATH/src/github.com/openshift/installer/
ulimit -S -n 4096
export GOROOT=$HOME/.gvm/gos/go1.9.1
export PATH="`pwd`/tectonic-dev/installer/:$PATH"
export CLUSTER_NAME="test1"
export BASE_DOMAIN="tt.testing"
export KUBECONFIG="`pwd`/$CLUSTER_NAME/generated/auth/kubeconfig"

