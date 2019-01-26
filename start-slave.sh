#!/bin/bash

SERVER_PORT=1099
jmeter -Dserver_port=$SERVER_PORT -Jserver.rmi.ssl.disable=true \
    -Djava.rmi.server.useLocalHostName=true -j /dev/stdout -s "$@"
