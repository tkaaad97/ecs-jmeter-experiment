#!/bin/bash

set -x

SERVER_IP=$(curl "${ECS_CONTAINER_METADATA_URI}/task" | jq -r '.Containers[0].Networks[0].IPv4Addresses[0]')
SERVER_PORT=1099

jmeter -Dserver_port=$SERVER_PORT -Jserver.rmi.ssl.disable=true \
    -D"java.rmi.server.hostname=$SERVER_IP" \
    -j /dev/stdout -s "$@"
