#!/bin/bash
docker pull golang:1.10-stretch
docker pull python:3.6-slim-stretch
PEBBLE_CHECKOUT=6133f3e187a93ddf81f509123dfe9f5b60d519bf
docker image build --network host --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
