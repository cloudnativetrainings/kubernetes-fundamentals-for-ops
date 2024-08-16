#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source .trainingrc

# create folders
mkdir -p /etc/etcd/

# install etcd
wget -q --show-progress --https-only --timestamping \
  "https://github.com/coreos/etcd/releases/download/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz"
tar -xvf etcd-v$ETCD_VERSION-linux-amd64.tar.gz
install -o root -m 0755 etcd-v$ETCD_VERSION-linux-amd64/etcd* /usr/local/bin

# copy etcd certs
install -o root -m 0644 ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

# create etcd service file
export INTERNAL_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
export ETCD_NAME=$(hostname -s)
export MASTER_0_IP=$(dig +short master-0)
export MASTER_1_IP=$(dig +short master-1)
export MASTER_2_IP=$(dig +short master-2)

envsubst < etcd.service > etcd.service.subst
install -o root -m 0644 etcd.service.subst /etc/systemd/system/etcd.service

# start etcd service
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
