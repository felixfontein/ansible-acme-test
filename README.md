# acme-certificate-test

A [Docker](https://en.wikipedia.org/wiki/Docker_(software))-based test suite for Ansible's [acme_account](https://docs.ansible.com/ansible/devel/modules/acme_account_module.html), [acme_certificate](https://docs.ansible.com/ansible/devel/modules/acme_certificate_module.html) and [acme_certificate_revoke](https://docs.ansible.com/ansible/devel/modules/acme_certificate_revoke_module.html) modules.

Uses [Pebble](https://github.com/letsencrypt/Pebble) as the ACME-based CA, [nginx](https://nginx.org/) as a webserver (for fulfilling `http-01` challenges) and [BIND 9](https://www.isc.org/downloads/bind/) as a DNS resolver (for fulfilling `dns-01` challenges).

## Usage

Run `./build.sh` to build the Docker containers for Python 2 and 3.

Run `./run.sh` to run the tests with these docker containers.

## TODO

- Add more tests
  - more certificates (with more domains)
  - revocation of certificates
- With a later version of Pebble, add test for account key change
