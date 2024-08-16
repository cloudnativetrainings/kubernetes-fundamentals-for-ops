#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source .trainingrc

# create folders
mkdir -p /etc/kubernetes/config/

# create kube-scheduler service file
install -o root -m 0644 kube-scheduler.service /etc/systemd/system/kube-scheduler.service

# copy the kube-scheduler config
install -o root -m 0644 kube-scheduler.yaml /etc/kubernetes/config/kube-scheduler.yaml

# start kube-scheduler service
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler
