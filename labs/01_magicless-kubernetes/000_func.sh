#!/bin/sh

node_sans() {
  node="$1";shift
  echo -n "${node},"
  docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${node}
}
