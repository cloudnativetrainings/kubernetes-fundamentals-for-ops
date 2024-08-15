#!/bin/bash

set -euxo pipefail

export NETWORK_NAME="k8s-net"

docker network create ${NETWORK_NAME}
