#!/bin/bash

set -euxo pipefail

source .trainingrc

source ./000_func.sh

export UBUNTU_IMAGE="quay.io/kubermatic-labs/devcontainers:ubuntu-2404-006"

docker pull ${UBUNTU_IMAGE}

touch /tmp/hosts

for i in 0 1 2
do
  docker run -d --network ${NETWORK_NAME} \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup \
    --cgroupns host \
    --name "master-${i}" --hostname "master-${i}" \
    --privileged ${UBUNTU_IMAGE}
  sleep 1
  echo "$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' master-${i}) master-${i}.kubernetes.local master-${i}" >> /tmp/hosts
done

for i in 0 1 2
do
  docker run -d --network ${NETWORK_NAME} \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /sys/fs/cgroup:/sys/fs/cgroup \
    --cgroupns host \
    --name "worker-${i}" \
    --hostname "worker-${i}" \
    --tmpfs /tmp \
    --tmpfs /run \
    --tmpfs /run/lock \
    --volume /var \
    --privileged ${UBUNTU_IMAGE}
  sleep 1
  echo "$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' worker-${i}) worker-${i}.kubernetes.local worker-${i}" >> /tmp/hosts
done

echo "$( vip_ip ) server.kubernetes.local server" >> /tmp/hosts

for node in master worker
do
  for i in 0 1 2
  do
    docker cp /tmp/hosts ${node}-${i}:.
    docker exec -it ${node}-${i} bash -c 'cat ./hosts >> /etc/hosts'
  done
done

cat /tmp/hosts >> /etc/hosts
