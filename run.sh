#!/bin/bash
set -e

POSTFIX="$(date +'%Y%m%d-%H%M%S')-$(dd if=/dev/urandom bs=1 count=8 2> /dev/null | od -A n -v -t x1 | tr -d ' \n')"

clean() {
  docker rm -f ${CONTAINER_NAME}
  rm -rf ${OUTPUT_DIR}
}

# Determine names and set up cleanup
CONTAINER_NAME="acme-certificate-test-${POSTFIX}"
OUTPUT_DIR="output-${POSTFIX}"
trap "{ docker logs ${CONTAINER_NAME} ; clean ; }" EXIT

# Start container
docker run --detach --name ${CONTAINER_NAME} --publish-all=true local/ansible/acme-test-container:latest
TEST_CONTAINER_IP=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' ${CONTAINER_NAME})

# Run tests
mkdir ${OUTPUT_DIR}
export acme_host=${TEST_CONTAINER_IP}
ansible-playbook --extra-vars "output_dir_master=${OUTPUT_DIR}" test.yml

# Cleanup
clean
trap - EXIT
