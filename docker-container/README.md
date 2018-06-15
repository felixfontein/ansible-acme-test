= acme-test-container

ACME CA test container for testing. Uses [Pebble](https://github.com/letsencrypt/Pebble) and [BIND 9](https://www.isc.org/downloads/bind/).

== Usage

Building the image locally
```
docker image build -t local/ansible/acme-test-container:latest .
```

Building the image locally with a different version of Pebble checked out
```
docker image build --build-arg PEBBLE_CHECKOUT=<hash|branch|tag> -t local/ansible/acme-test-container:<hash|branch|tag> .
```
