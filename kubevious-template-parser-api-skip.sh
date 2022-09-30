#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

OUTPUT_DIR=output/parser-api-skip
rm -rf ${OUTPUT_DIR}

helm template kubevious ./kubernetes --debug \
    -n kubevious \
    -f dev/overrides-parser-api-skip.yaml \
    --output-dir ${OUTPUT_DIR}