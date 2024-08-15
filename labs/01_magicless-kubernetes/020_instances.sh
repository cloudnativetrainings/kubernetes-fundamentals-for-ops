#!/bin/bash

set -euxo pipefail

export UBUNTU_IMAGE="quay.io/kubermatic-labs/devcontainers:ubuntu-2404-001"
export NETWORK_NAME="k8s-net"

docker pull ${UBUNTU_IMAGE}

for type in master worker
do
  for i in 0 1 2
  do
    docker run -d --network ${NETWORK_NAME} -v /var/run/docker.sock:/var/run/docker.sock \
      --name "${type}-${i}" ${UBUNTU_IMAGE}
  done
done
