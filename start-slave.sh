#!/bin/bash

set -x

SERVER_IP=$(curl -q http://169.254.169.254/latest/meta-data/local-ipv4)
SERVER_PORT=1099

jmeter -Dserver_port=$SERVER_PORT -Jserver.rmi.ssl.disable=true \
    -D"java.rmi.server.hostname=$SERVER_IP" \
    -j /dev/stdout -s "$@"
