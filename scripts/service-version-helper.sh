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
    fetchBinaryVersion ${REPO_NAME}
    echo "${REPO_NAME} VERSION: ${PRODUCT_VERSION}"

    yq ".${REPO_NAME}.image.tag = \"${PRODUCT_VERSION}\"" -i values.yaml
}
