#!/bin/bash
#!/usr/bin/env bash

# Usage:
# $ source oc-localdown.sh
#
# To make this convenient, add to .bashrc:
# alias ocdown="source /PATH/TO/oc-localdown.sh"

# This script shutsdown a cluster.

oc cluster down
docker rm -f bindmountproxy
