#!/bin/bash

fetchBinaryVersion () {
    local REPO_NAME=${1}
    echo "fetchBinaryVersion REPO_NAME: ${REPO_NAME}"
    local GIT_PATH="https://raw.githubusercontent.com/kubevious/${REPO_NAME}/master/version.sh"
    source /dev/stdin <<< "$(curl -s ${GIT_PATH})"
    echo "FETCHED ${REPO_NAME} VERSION: ${PRODUCT_VERSION}"
}

processBinary () {
    local REPO_NAME=${1}
    local VALUE_NAME=${2}
    if [[ -z "$VALUE_NAME" ]]; then
        VALUE_NAME="${REPO_NAME}"
    fi
    echo "[processBinary] REPO_NAME=${REPO_NAME}"
    echo "[processBinary] VALUE_NAME=${VALUE_NAME}"

    fetchBinaryVersion ${REPO_NAME}
    echo "${REPO_NAME} VERSION: ${PRODUCT_VERSION}"

    yq ".${VALUE_NAME}.image.tag = \"${PRODUCT_VERSION}\"" -i values.yaml
}
