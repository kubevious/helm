#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

rm -rf output

helm template kubevious ./kubernetes --debug \
    -n kubevious \
    -f dev/overrides.yaml \
    --output-dir output/