#!/bin/bash
#!/usr/bin/env bash

# This script adds prometheus to a Kubernetes cluster.
kubectl apply -f $GOPATH/src/github.com/coreos/prometheus-operator/contrib/kube-prometheus/manifests