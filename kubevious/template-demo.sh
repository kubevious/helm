#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

OUTPUT_DIR=output/demo
rm -rf ${OUTPUT_DIR}

helm template kubevious ./chart --debug \
    -n kubevious \
    -f overrides/overrides-demo.yaml \
    --kube-version "1.20.15" \
    --output-dir ${OUTPUT_DIR}