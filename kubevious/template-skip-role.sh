#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

OUTPUT_DIR=output/skip-role
rm -rf ${OUTPUT_DIR}

helm template kubevious ./chart --debug \
    -n kubevious \
    -f overrides/overrides-skip-role-binding.yaml \
    --output-dir ${OUTPUT_DIR}