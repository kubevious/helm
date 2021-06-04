#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

rm -rf output

helm template kubevious ./kubernetes \
    -n kubevious \
    -f dev/overrides-node-selector.yaml \
    --version 0.8.15 \
    --output-dir output/