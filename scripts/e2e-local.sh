#!/bin/bash
#!/usr/bin/env bash

# This scripts run a single e2e test in kube against a local up cluster.
export KUBE_MASTER_IP="127.0.0.1:8080"
export KUBE_MASTER=local
go run hack/e2e.go -- --check-version-skew=false -v --test --test_args="--ginkgo.focus=ResourceQuota" --provider=local

