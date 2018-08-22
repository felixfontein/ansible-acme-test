#!/bin/bash
docker pull golang:1.10-stretch
docker pull python:3.6-slim-stretch
PEBBLE_CHECKOUT=35f569333bca2b780147889c42d9f75fa8770057
docker image build --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
