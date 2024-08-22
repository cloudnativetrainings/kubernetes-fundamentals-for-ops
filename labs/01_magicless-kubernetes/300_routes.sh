#!/bin/bash

set -euxo pipefail

export WORKER_0_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' worker-0)
export WORKER_1_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' worker-1)
export WORKER_2_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' worker-2)


for i in 0 1 2
do
    docker exec -it master-${i} ip route add 192.168.10.0/24 via ${WORKER_0_IP}
    docker exec -it master-${i} ip route add 192.168.11.0/24 via ${WORKER_1_IP}
    docker exec -it master-${i} ip route add 192.168.12.0/24 via ${WORKER_2_IP}
done

# worker-0 routes
docker exec -it worker-0 ip route add 192.168.11.0/24 via ${WORKER_1_IP}
docker exec -it worker-0 ip route add 192.168.12.0/24 via ${WORKER_2_IP}

# worker-1 routes
docker exec -it worker-1 ip route add 192.168.10.0/24 via ${WORKER_0_IP}
docker exec -it worker-1 ip route add 192.168.12.0/24 via ${WORKER_2_IP}

# worker-2 routes
docker exec -it worker-2 ip route add 192.168.10.0/24 via ${WORKER_0_IP}
docker exec -it worker-2 ip route add 192.168.11.0/24 via ${WORKER_1_IP}
