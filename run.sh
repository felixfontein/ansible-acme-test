#!/bin/bash
set -e

POSTFIX="$(date +'%Y%m%d-%H%M%S')-$(dd if=/dev/urandom bs=1 count=8 2> /dev/null | od -A n -v -t x1 | tr -d ' \n')"

clean() {
  docker rm -f ${CONTAINER_NAME}
  docker network rm ${NETWORK_NAME}
  rm -rf ${OUTPUT_DIR}
}

# Determine names and set up cleanup
CONTAINER_NAME="acme-certificate-test-${POSTFIX}"
NETWORK_NAME="acme_certificate_test$(echo ${POSTFIX} | sed -e 's/-/_/g')"
NETWORK_PREFIX=$(echo ${RANDOM} | cut -c 1-4)
OUTPUT_DIR="output-${POSTFIX}"
trap "{ docker logs ${CONTAINER_NAME} ; clean ; }" EXIT

# Start network
echo "Creating temporary network ${NETWORK_NAME} for IPv6 subnet ${NETWORK_PREFIX}::/64"
docker network create --ipv6 --subnet ${NETWORK_PREFIX}::/64 ${NETWORK_NAME}

# Start container
docker run --detach --network ${NETWORK_NAME} --name ${CONTAINER_NAME} --publish-all=true local/ansible/acme-test-container:latest
TEST_CONTAINER_IP=$(docker inspect -f "{{.NetworkSettings.Networks.${NETWORK_NAME}.IPAddress}}" ${CONTAINER_NAME})
echo "Container IP: ${TEST_CONTAINER_IP}"

# Run tests
mkdir ${OUTPUT_DIR}
export acme_host=${TEST_CONTAINER_IP}
ansible-playbook --extra-vars "output_dir_master=${OUTPUT_DIR}" test.yml

# Cleanup
clean
trap - EXIT
