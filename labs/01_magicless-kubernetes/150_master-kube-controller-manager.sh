#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source .trainingrc

# create kube-apiserver service file
install -o root -m 0644 kube-controller-manager.service /etc/systemd/system/kube-controller-manager.service

# start kube-controller-manager service
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager
