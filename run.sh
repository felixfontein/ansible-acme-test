#!/bin/bash
set -e

run_tests() {
    POSTFIX="$(date +'%Y%m%d-%H%M%S')-$(dd if=/dev/urandom bs=1 count=8 2> /dev/null | od -A n -v -t x1 | tr -d ' \n')"
    echo "======================================================================================================="
    echo "================================== RUNNING PYTHON $1 TESTS WITH POSTFIX ${POSTFIX}"
    echo "======================================================================================================="

    # Determine names and set up cleanup
    INVENTORY_NAME="inventory-${POSTFIX}"
    CONTAINER_NAME="acme-certificate-test-${POSTFIX}"
    OUTPUT_DIR="output-${POSTFIX}"
    trap "{ docker rm -f ${CONTAINER_NAME} ; rm -rf ${INVENTORY_NAME} ; rm -rf ${OUTPUT_DIR} ; }" EXIT

    # Start container
    docker run --detach --name ${CONTAINER_NAME} --publish-all=true pebble:$1
    PEBBLE_PORT=$(docker port ${CONTAINER_NAME} 14000/tcp | sed -E 's/^.*:([0-9]+)/\1/g')

    # Set up inventory
    echo "host ansible_connection=docker ansible_host=${CONTAINER_NAME} ansible_python_interpreter=$2" > ${INVENTORY_NAME}

    # Run tests
    mkdir ${OUTPUT_DIR}
    ansible-playbook -i ${INVENTORY_NAME} --extra-vars "pebble_port=${PEBBLE_PORT} output_dir=${OUTPUT_DIR}" test.yml

    # Cleanup
    docker rm -f ${CONTAINER_NAME}
    rm -rf ${INVENTORY_NAME}
    rm -rf ${OUTPUT_DIR}
}

run_tests 2 /usr/bin/python2.7
run_tests 3 /usr/bin/python3
