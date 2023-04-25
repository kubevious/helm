#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

OUTPUT_DIR=output/other
rm -rf ${OUTPUT_DIR}

docker run -ti --rm -v $(pwd):/apps \
    -v ~/.kube:/root/.kube \
    -v ~/.helm:/root/.helm alpine/helm:3.1.0 \
    template kubevious /apps/chart --debug \
    -n kubevious \
    -f /apps/overrides/overrides.yaml \
    --output-dir /apps/${OUTPUT_DIR}