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
export KUBECONFIG=.kubeconfig
#export KUBECONFIG="`pwd`/openshift.local.config/master/admin.kubeconfig"
#export CURL_CA_BUNDLE="`pwd`/openshift.local.config/master/ca.crt"
#alias curlapi="curl --cert `pwd`/openshift.local.config/master/admin.crt --key `pwd`/openshift.local.config/master/admin.key"

export OS_OUTPUT_GOPATH=1
export OS_ROOT="${GOPATH}/src/github.com/openshift/origin"
export GO_OUT="${OS_ROOT}/_output/local/bin/linux/amd64/"
export PATH="${GO_OUT}:${PATH}"

export ETCDCTL_ENDPOINTS=https://localhost:4001
export ETCDCTL_CA_FILE="`pwd`/openshift.local.config/master/ca.crt"
export ETCDCTL_CERT_FILE="`pwd`/openshift.local.config/master/admin.crt"
export ETCDCTL_KEY_FILE="`pwd`/openshift.local.config/master/admin.key"