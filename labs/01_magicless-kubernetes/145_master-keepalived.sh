#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source .trainingrc


# setup keepalived
IP_ADDR=$(dig +short $HOSTNAME)
export APISERVER_VIP=$(echo "${IP_ADDR%\.*}.100")

if [ "$HOSTNAME" == 'master-0' ]; then
  export STATE="MASTER"
  export PRIORITY="101"
else
  export STATE="BACKUP"
  export PRIORITY="100"
fi
export AUTH_PASS=$(head -c 32 /dev/urandom | base64)

envsubst < check_apiserver.sh > check_apiserver.sh.subst
envsubst < keepalived.conf > keepalived.conf.subst

install -o root -m 755 check_apiserver.sh.subst /etc/keepalived/check_apiserver.sh
install -o root -m 644 keepalived.conf.subst /etc/keepalived/keepalived.conf

systemctl restart keepalived
