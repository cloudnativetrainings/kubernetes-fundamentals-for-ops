#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source .trainingrc

# create folders
sudo mkdir -p /etc/etcd/

# install etcd
wget -q --show-progress --https-only --timestamping \
  "https://github.com/coreos/etcd/releases/download/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz"
tar -xvf etcd-v$ETCD_VERSION-linux-amd64.tar.gz
sudo install -o root -m 0755 etcd-v$ETCD_VERSION-linux-amd64/etcd* /usr/local/bin

# copy etcd certs
sudo install -o root -m 0644 ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

# create etcd service file
export INTERNAL_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
export ETCD_NAME=$(hostname -s)

MASTER_0_IP=$(dig +short master-0)
MASTER_1_IP=$(dig +short master-1)
MASTER_2_IP=$(dig +short master-2)

/usr/local/bin/etcd \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls=https://${INTERNAL_IP}:2380 \
  --listen-peer-urls=https://${INTERNAL_IP}:2380 \
  --listen-client-urls=https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \
  --advertise-client-urls=https://${INTERNAL_IP}:2379 \
  --initial-cluster-token=etcd-cluster-0 \
  --initial-cluster master-0=https://${MASTER_0_IP}:2380,master-1=https://${MASTER_1_IP}:2380,master-2=https://${MASTER_2_IP}:2380 \
  --initial-cluster-state=new \
  --data-dir=/var/lib/etcd &> /var/log/etcd.log &
