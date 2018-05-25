#!/bin/bash
# config options
USE_METRICS="false"
USE_LOGGING="false"
USE_EXISTING_CONFIG="true"
HOST_DATA_DIR="/home/decarr/scripts/oc-data"
HOST_CONFIG_DIR="/home/decarr/scripts/oc-config"
LOG_LEVEL="6"

# configure a bind mount proxy (requires openshift compiled)
IP=$(openshift start --print-ip)
docker run --privileged --net=host -v /var/run/docker.sock:/var/run/docker.sock -d --name=bindmountproxy cewong/bindmountproxy proxy ${IP}:2375 $(which openshift)
sleep 2
docker_host=tcp://${IP}:2375

# start openshift
DOCKER_HOST=${docker_host} oc cluster up \
--server-loglevel=${LOG_LEVEL} \
--host-data-dir=${HOST_DATA_DIR} \
--host-config-dir=${HOST_CONFIG_DIR} \
--use-existing-config=${USE_EXISTING_CONFIG} \
-e DOCKER_HOST=${docker_host}
