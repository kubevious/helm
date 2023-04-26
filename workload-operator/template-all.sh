#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd ${MY_DIR}

OUTPUT_BASE_DIR=${MY_DIR}/output
rm -rf ${OUTPUT_BASE_DIR}

OVERRIDES_DIR=${MY_DIR}/overrides

NAMESPACE=workload-operator

for f in ${OVERRIDES_DIR}/*.yaml; do
    echo "OVERRIDE >>> $f";
    NAME=$(basename -s .yaml $f)
    echo "           | $NAME";

    OUTPUT_DIR=${OUTPUT_BASE_DIR}/${NAME}

    helm template workload-operator ./chart --debug \
        -n ${NAMESPACE} \
        -f $f \
        --output-dir ${OUTPUT_DIR}

    EXITCODE=$?
    if [ $EXITCODE -ne 0 ]; then
        echo "ERROR templating overrides: $f";
        exit 1;
    fi
done
