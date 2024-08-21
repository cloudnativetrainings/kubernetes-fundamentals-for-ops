#!/bin/false

# this is meant to be run on each worker node

set -euxo pipefail

source .trainingrc

# create folders
mkdir -p /var/lib/kube-proxy/

# download and install binary
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kube-proxy"
install -o root -m 0755 kube-proxy /usr/local/bin/

# copy secrets
install -o root -m 0600 kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig

# create kube-proxy config file
export POD_CIDR="192.168.1$(hostname | tail -c 2).0/24"
envsubst < kube-proxy-config.yaml > kube-proxy-config.yaml.subst
install -o root -m 0644 kube-proxy-config.yaml.subst /var/lib/kube-proxy/kube-proxy-config.yaml

# create kube-proxy service file
install -o root -m 0644 kube-proxy.service /etc/systemd/system/kube-proxy.service

# start kubelet service
systemctl daemon-reload
systemctl enable kube-proxy
systemctl start kube-proxy
