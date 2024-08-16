#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source .trainingrc

# create kube-apiserver service file
export INTERNAL_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

export MASTER_0_IP=$(dig +short master-0)
export MASTER_1_IP=$(dig +short master-1)
export MASTER_2_IP=$(dig +short master-2)

envsubst < kube-apiserver.service > kube-apiserver.service.subst
install -o root -m 0644 kube-apiserver.service.subst /etc/systemd/system/kube-apiserver.service

# start kube-apiserver service
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
