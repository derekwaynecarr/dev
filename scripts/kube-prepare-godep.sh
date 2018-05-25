#!/bin/bash

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Convenience script to manage godep dependencies in a separate workspace.
# Useful if you need to update godeps.

set -o errexit
set -o nounset
set -o pipefail

# populate your username
export GITHUB_USERNAME=derekwaynecarr

# install godep
export GOPATH=$HOME/go-tools
mkdir -p $GOPATH
go get -u github.com/tools/godep

# configure a separate workspace for this work
export PATH=$GOPATH/bin:$PATH
export KPATH=$HOME/code/kubernetes
rm -fr $KPATH
mkdir -p $KPATH/src/k8s.io
cd $KPATH/src/k8s.io
git clone https://github.com/$GITHUB_USERNAME/kubernetes.git

# restore
export GOPATH=$KPATH
cd $KPATH/src/k8s.io/kubernetes
godep restore