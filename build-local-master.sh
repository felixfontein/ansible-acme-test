#!/bin/bash
docker pull golang:1.10-stretch
docker image build --build-arg PEBBLE_CHECKOUT=master -t local/ansible/acme-test-container:latest docker-container
