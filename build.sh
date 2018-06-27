#!/bin/bash
docker pull golang:1.10-stretch
PEBBLE_CHECKOUT=703daa840c5306f55085548ad8fb26b5adbd9daf
docker image build --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
