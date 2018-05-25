# Usage:
# $ source oc-localup.sh
#
# To make this convenient, add to .bashrc:
# alias ocup="source /PATH/TO/ocup.sh"

# spins up openshift using oc cluster up, but locally built code.
# will also install service catalog (for now).

# config options
USE_METRICS="false"
USE_LOGGING="false"
USE_EXISTING_CONFIG="false"
USE_SERVICE_CATALOG="false"
HOST_DATA_DIR="`pwd`/openshift.local.data"
#HOST_CONFIG_DIR="`pwd`/openshift.local.config"
HOST_CONFIG_DIR="/var/lib/origin/openshift.local.config"
LOG_LEVEL="5"

# configure a bind mount proxy (requires openshift compiled)
IP=$(openshift start --print-ip)
docker run --privileged --net=host -v /var/run/docker.sock:/var/run/docker.sock -d --name=bindmountproxy cewong/bindmountproxy proxy ${IP}:2375 $(which openshift)
sleep 2
docker_host=tcp://${IP}:2375

# start openshift
DOCKER_HOST=${docker_host} oc cluster up \
--server-loglevel=${LOG_LEVEL} \
--metrics=${USE_METRICS} \
--logging=${USE_LOGGING} \
--host-data-dir=${HOST_DATA_DIR} \
--host-config-dir=${HOST_CONFIG_DIR} \
--use-existing-config=${USE_EXISTING_CONFIG} \
--version="v3.9.0" \
--service-catalog=${USE_SERVICE_CATALOG} \
-e DOCKER_HOST=${docker_host}