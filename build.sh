#!/bin/bash
docker pull golang:1.10-stretch
PEBBLE_CHECKOUT=25448686e9b499e42380ddf965d8e23bd794378c
docker image build --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
