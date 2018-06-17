#!/bin/bash
docker pull golang:1.10-stretch
PEBBLE_CHECKOUT="master" docker image build -t local/ansible/acme-test-container:latest docker-container
