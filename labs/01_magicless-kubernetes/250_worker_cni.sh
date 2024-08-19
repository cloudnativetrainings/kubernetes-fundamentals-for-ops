#!/bin/false

# this is meant to be run on each worker node

set -euxo pipefail

source .trainingrc

# create folders
mkdir -p /opt/cni/bin/ /etc/cni/net.d/

# download and install bridge network binary
wget -q --show-progress --https-only --timestamping \
  "https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz"
tar zxvf cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz -C /opt/cni/bin/
rm -f cni-plugins-linux-amd64-vv${CNI_PLUGINS_VERSION}.tgz

# create cni config files
export POD_CIDR="192.168.1$(hostname | tail -c 2).0/24"
envsubst < 10-bridge.conf > 10-bridge.conf.subst

install -o root -m 0644 10-bridge.conf.subst /etc/cni/net.d/10-bridge.conf
install -o root -m 0644 99-loopback.conf /etc/cni/net.d/99-loopback.conf
