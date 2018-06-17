#!/bin/bash
docker pull golang:1.10-stretch
PEBBLE_CHECKOUT=c0cc64314be427c6d39679e95a7794c89a293912
docker image build --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
