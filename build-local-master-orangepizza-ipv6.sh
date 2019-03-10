#!/bin/bash
# docker pull golang:1.10-stretch
# docker pull python:3.6-slim-stretch
docker image build \
    --network host \
    --build-arg PEBBLE_REMOTE=https://github.com/orangepizza/pebble.git \
    --build-arg PEBBLE_CHECKOUT="ipv6" \
    -t local/ansible/acme-test-container:latest \
    docker-container
