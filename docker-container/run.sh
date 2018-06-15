#!/bin/sh
set -e
# Our internal BIND (started by Controller) is the official DNS resolver for this container
echo nameserver 127.0.0.1 > /etc/resolv.conf
# Start controller in background
export CONTROLLER_PORT=5000
export ZONES_PATH=/etc/bind/zones
/usr/bin/python3 /root/controller.py &
# Start Pebble
cd /go/src/github.com/letsencrypt/pebble
/go/bin/pebble -config /go/src/github.com/letsencrypt/pebble/test/config/pebble-config.json
