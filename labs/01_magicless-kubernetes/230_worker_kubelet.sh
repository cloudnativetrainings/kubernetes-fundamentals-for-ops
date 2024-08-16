#!/bin/false

# this is meant to be run on each worker node

set -euxo pipefail

source .trainingrc

# create folders
mkdir -p /var/lib/kubelet/

# download and install binary
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubelet"
install -o root -m 0755 kubelet /usr/local/bin/

# copy secrets
install -o root -m 0644 ca.pem /var/lib/kubelet/ca.pem
install -o root -m 0644 ${HOSTNAME}.pem /var/lib/kubelet/kubelet.pem
install -o root -m 0600 ${HOSTNAME}-key.pem /var/lib/kubelet/kubelet-key.pem
install -o root -m 0600 ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig

# create kubelet config file
export POD_CIDR="192.168.1$(hostname | tail -c 2).0/24"
envsubst < kubelet-config.yaml > kubelet-config.yaml.subst
install -o root -m 0644 kubelet-config.yaml.subst /var/lib/kubelet/kubelet-config.yaml

# create kubelet service file
install -o root -m 0644 kubelet.service /etc/systemd/system/kubelet.service

# start kubelet service
systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet
