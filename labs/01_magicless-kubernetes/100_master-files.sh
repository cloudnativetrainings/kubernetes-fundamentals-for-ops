#!/bin/bash

set -euxo pipefail

# copy secrets
for node in master-{0..2}; do
  docker cp secrets/ca.pem ${node}:.
  docker cp secrets/ca-key.pem ${node}:.
  docker cp secrets/kubernetes.pem ${node}:.
  docker cp secrets/kubernetes-key.pem ${node}:.
  docker cp secrets/service-account.pem ${node}:.
  docker cp secrets/service-account-key.pem ${node}:.
  docker cp secrets/encryption-config.yaml ${node}:.
  docker cp secrets/admin.kubeconfig ${node}:.
  docker cp secrets/kube-controller-manager.kubeconfig ${node}:.
  docker cp secrets/kube-scheduler.kubeconfig ${node}:.
done

# copy config files
for node in master-{0..2}; do
  docker cp services/etcd.service ${node}:.
  docker cp services/kube-apiserver.service ${node}:.
  docker cp services/kube-controller-manager.service ${node}:.
  docker cp services/kube-scheduler.service ${node}:.
  docker cp configs/kube-scheduler.yaml ${node}:.
  docker cp configs/kube-apiserver-to-kubelet.yaml ${node}:.
  docker cp configs/check_apiserver.sh ${node}:.
  docker cp configs/keepalived.conf ${node}:.
done

# copy shell scripts
for node in master-{0..2}; do
  docker cp 120_master-etcd.sh ${node}:.
  docker cp 130_master-kube-services-preps.sh ${node}:.
  docker cp 140_master-kube-apiserver.sh ${node}:.
  docker cp 145_master-keepalived.sh ${node}:.
  docker cp 150_master-kube-controller-manager.sh ${node}:.
  docker cp 160_master-kube-scheduler.sh ${node}:.
done

# copy .trainingrc file
for node in master-{0..2}; do
  docker cp .trainingrc ${node}:.
done
