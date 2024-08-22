#!/bin/bash

set -euxo pipefail

source .trainingrc

docker network create ${NETWORK_NAME} \
 -o "com.docker.network.bridge.enable_ip_masquerade"="true"
