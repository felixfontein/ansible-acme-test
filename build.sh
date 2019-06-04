#!/bin/bash
docker pull golang:1.10-stretch
docker pull python:3.6-slim-stretch
PEBBLE_CHECKOUT=c5de6e0ed64c8854fd27f85067ccbbb2dbe77862
docker image build --network host --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
