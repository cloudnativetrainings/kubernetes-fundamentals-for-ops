#!/bin/bash

set -euxo pipefail

source .trainingrc

docker network create ${NETWORK_NAME}
