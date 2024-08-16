#!/bin/false

# this is meant to be run on each worker node

set -euxo pipefail

source .trainingrc

# create folders
sudo mkdir -p /var/lib/kube-proxy/

# download and install binary
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kube-proxy"
sudo install -o root -m 0755 kube-proxy /usr/local/bin/

# copy secrets
sudo install -o root -m 0600 kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig

# create kube-proxy config file
sudo install -o root -m 0644 kube-proxy-config.yaml /var/lib/kube-proxy/kube-proxy-config.yaml

# start kube-proxy
/usr/local/bin/kube-proxy \
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml &> /var/log/kubelet.log &
