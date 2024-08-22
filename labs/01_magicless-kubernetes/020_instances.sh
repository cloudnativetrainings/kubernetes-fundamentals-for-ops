#!/bin/bash

set -euxo pipefail

source .trainingrc

export UBUNTU_IMAGE="quay.io/kubermatic-labs/devcontainers:ubuntu-2404-005"

docker pull ${UBUNTU_IMAGE}

for i in 0 1 2
do
  docker run -d --network ${NETWORK_NAME} \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup \
    --cgroupns host \
    --name "master-${i}" --hostname "master-${i}" \
    --privileged ${UBUNTU_IMAGE}
done

for i in 0 1 2
do
  mkdir -p /workspaces/worker-${i}/containerd
  docker run -d --network ${NETWORK_NAME} \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /workspaces/containerd/worker-${i}:/var/lib/containerd \
    --cgroupns host \
    --name "worker-${i}" \
    --hostname "worker-${i}" \
    --privileged ${UBUNTU_IMAGE}
done
