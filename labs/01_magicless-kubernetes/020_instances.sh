#!/bin/bash

set -euxo pipefail

export UBUNTU_IMAGE="quay.io/kubermatic-labs/devcontainers:ubuntu-2404-003"
export NETWORK_NAME="k8s-net"

docker pull ${UBUNTU_IMAGE}

for i in 0 1 2
do
  docker run -d --network ${NETWORK_NAME} \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup \
    --name "master-${i}" --hostname "master-${i}" \
    --privileged ${UBUNTU_IMAGE}
done

for i in 0 1 2
do
  mkdir -p /workspaces/containerd/worker-${i}
  docker run -d --network ${NETWORK_NAME} \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup \
    --volume /workspaces/containerd/worker-${i}:/var/lib/containerd \
    --name "worker-${i}" \
    --hostname "worker-${i}" \
    --privileged ${UBUNTU_IMAGE}
done
