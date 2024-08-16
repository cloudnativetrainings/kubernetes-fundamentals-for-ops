#!/bin/bash

set -euxo pipefail

source .trainingrc

# copy secrets
for node in worker-{0..2}; do
  docker cp secrets/${node}.pem ${node}:.
  docker cp secrets/${node}-key.pem ${node}:.
  docker cp secrets/${node}.kubeconfig ${node}:.
  docker cp secrets/kube-proxy.kubeconfig ${node}:.
  docker cp secrets/ca.pem ${node}:.
done

# copy config files
for node in worker-{0..2}; do
  docker cp configs/10-bridge.conf ${node}:.
  docker cp configs/99-loopback.conf ${node}:.
  docker cp configs/containerd-config.toml ${node}:.
  docker cp configs/crictl.yaml ${node}:.
  docker cp configs/kube-proxy-config.yaml ${node}:.
  docker cp configs/kubelet-config.yaml ${node}:.
  docker cp services/containerd.service ${node}:.
  docker cp services/kube-proxy.service ${node}:.
  docker cp services/kubelet.service ${node}:.
done

# copy shell scripts
for node in worker-{0..2}; do
  docker cp 220_worker_cre.sh ${node}:.
  docker cp 230_worker_kubelet.sh ${node}:.
  docker cp 240_worker_kube-proxy.sh ${node}:.
  docker cp 250_worker_cni.sh ${node}:.
done

# copy .trainingrc file
for node in worker-{0..2}; do
    docker cp .trainingrc ${node}:.
done
