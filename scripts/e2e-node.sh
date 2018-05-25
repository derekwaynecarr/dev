#!/bin/bash
#!/usr/bin/env bash

# This scripts run a e2e test in kube against a local up cluster.
export FOCUS="HugePages"
export PARALLELISM="1"
export TEST_ARGS='--report-dir="" --kubelet-flags="--feature-gates=DynamicKubeletConfig=true --fail-swap-on=false --cgroup-driver=systemd" --ginkgo.skip=""'
make test-e2e-node