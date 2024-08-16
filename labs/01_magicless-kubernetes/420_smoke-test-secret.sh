#!/bin/bash

set -euxo pipefail

source .trainingrc

kubectl --kubeconfig secrets/admin.kubeconfig create secret generic "magicless" \
  --from-literal="mykey=mydata"

# print hexdump etcd value
docker exec -it master-0 bash -c \
  "ETCDCTL_API=3 etcdctl get \
      --endpoints=https://127.0.0.1:2379 \
      --cacert=/etc/etcd/ca.pem \
      --cert=/etc/etcd/kubernetes.pem \
      --key=/etc/etcd/kubernetes-key.pem \
      /registry/secrets/default/magicless | hexdump -C"
      