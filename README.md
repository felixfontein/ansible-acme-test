# acme-certificate-test

A [Docker](https://en.wikipedia.org/wiki/Docker_(software))-based test suite for Ansible's [acme_account](https://docs.ansible.com/ansible/devel/modules/acme_account_module.html), [acme_certificate](https://docs.ansible.com/ansible/devel/modules/acme_certificate_module.html) and [acme_certificate_revoke](https://docs.ansible.com/ansible/devel/modules/acme_certificate_revoke_module.html) modules.

Uses [Pebble](https://github.com/letsencrypt/Pebble) as the ACME-based CA and [BIND 9](https://www.isc.org/downloads/bind/) as a DNS resolver (for fulfilling `dns-01` challenges).

## Usage

Run `./build-local-master.sh` to build a local version of the Docker container. An “official” build (built with `build.sh`) can be found [on Docker Hub](https://hub.docker.com/r/felixfontein/acme-test-container/).

Run `./run.sh` to run the tests with this (local) docker container.

## TODO

- Add more tests
  - more certificates (with more domains)
  - revocation of certificates
- With a later version of Pebble, add test for account key change
