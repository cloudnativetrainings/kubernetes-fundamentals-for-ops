#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source .trainingrc

# create folders
sudo mkdir -p /etc/kubernetes/config/

# copy the kube-scheduler config
sudo install -o root -m 0644 kube-scheduler.yaml /etc/kubernetes/config/kube-scheduler.yaml

/usr/local/bin/kube-scheduler \
  --config=/etc/kubernetes/config/kube-scheduler.yaml \
  --v=2  &> /var/log/kube-scheduler.log &
