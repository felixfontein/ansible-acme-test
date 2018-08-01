#!/bin/bash
docker pull golang:1.10-stretch
docker pull python:3.6-slim-stretch
PEBBLE_CHECKOUT=758293c7c0952a68600d001886c5f60f48629964
docker image build --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
