#!/bin/bash

cat > /etc/default/docker <<EOF
DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --userland-proxy=false --registry-mirror=http://192.168.27.100:4000 --insecure-registry=192.168.27.100:4000"
EOF
service docker restart