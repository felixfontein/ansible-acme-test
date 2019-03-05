#!/bin/bash
docker pull golang:1.10-stretch
docker pull python:3.6-slim-stretch
PEBBLE_CHECKOUT=1f851bf3f6b0c22d2f59c1e8958b79e0ab7ad580
docker image build --network host --build-arg PEBBLE_CHECKOUT=${PEBBLE_CHECKOUT} -t felixfontein/acme-test-container:${PEBBLE_CHECKOUT} docker-container
docker push felixfontein/acme-test-container:${PEBBLE_CHECKOUT}
