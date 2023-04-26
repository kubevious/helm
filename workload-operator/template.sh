#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

OUTPUT_DIR=output/default
rm -rf ${OUTPUT_DIR}

helm template workload-operator ./chart --debug \
    -n workload-operator \
    --output-dir ${OUTPUT_DIR}