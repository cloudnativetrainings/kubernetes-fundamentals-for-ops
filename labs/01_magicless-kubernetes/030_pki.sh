#!/bin/bash

set -euxo pipefail

source ./000_func.sh

MASTER_0_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' master-0)
MASTER_1_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' master-1)
MASTER_2_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' master-2)

cfssl gencert -initca secrets/ca-csr.json | cfssljson -bare secrets/ca

# arguments: CN filename group SANs
mkcert() {
  cn="$1" ; shift
  filename="$1" ; shift
  group="$1" ; shift
  sans="$1" ; shift

  cfssl gencert \
    -ca=secrets/ca.pem -ca-key=secrets/ca-key.pem -config=secrets/ca-config.json -profile=kubernetes \
    -hostname=${sans} \
    <(cat <<EOF
      {
        "CN": "$cn",
        "key": { "algo": "rsa", "size": 2048 },
        "names": [
          {
            "C": "DE",
            "L": "Hamburg",
            "O": "$group",
            "OU": "Kubernetes The Hard Way",
            "ST": "Hamburg"
          }
        ]
      }
EOF
     ) | cfssljson -bare secrets/${filename}
}

# admin user client cert:
# (CN filename group SANs)
mkcert admin admin system:masters ""

# worker nodes
mkcert system:node:worker-0 worker-0 system:nodes $( node_sans worker-0 )
mkcert system:node:worker-1 worker-1 system:nodes $( node_sans worker-1 )
mkcert system:node:worker-2 worker-2 system:nodes $( node_sans worker-2 )

# master components
mkcert system:kube-controller-manager kube-controller-manager system:kube-controller-manager ""
mkcert system:kube-proxy kube-proxy system:node-proxier ""
mkcert system:kube-scheduler kube-scheduler system:kube-scheduler ""
mkcert service-accounts service-account Kubernetes ""
mkcert kubernetes kubernetes system:masters 10.32.0.1,kubernetes.default,127.0.0.1,${MASTER_0_IP},${MASTER_1_IP},${MASTER_2_IP},$( vip_ip )
