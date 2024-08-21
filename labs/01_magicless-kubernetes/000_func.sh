#!/bin/sh

source .trainingrc

node_sans() {
  node="$1";shift
  echo -n "${node},"
  docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${node}
}

vip_ip() {
  SUBNET=$(docker network inspect --format='{{range .IPAM.Config}}{{.Subnet}}{{end}}' ${NETWORK_NAME})
  # transform Subnet to IP. e.g.: 172.22.0.0/16 to 172.22.0.100
  echo "${SUBNET%\.*}.100"
}
