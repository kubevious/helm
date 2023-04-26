#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

CURRENT_CONTEXT=$(kubectl config current-context)
echo "Current context is: ${CURRENT_CONTEXT}"
echo "Will install Workload Operator now"
read -r -p "Do you want to continue?(y/N) " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        echo "Aborted"
        exit 1;
        ;;
esac

PRODUCT_NAME=workload-operator

VERSION=0.0.1

yq ".version = \"${VERSION}\"" -i chart/Chart.yaml 
yq ".appVersion = \"${VERSION}\"" -i chart/Chart.yaml

echo "**********"
cat chart/Chart.yaml 
echo "**********"

rm -f "${PRODUCT_NAME}-*.tgz"

helm package chart/ --version ${VERSION}

# Create namespace
kubectl create namespace ${PRODUCT_NAME}

# --debug
helm upgrade -i  \
    --atomic \
    -n ${PRODUCT_NAME} \
    -f overrides/default.yaml \
    ${PRODUCT_NAME} ./${PRODUCT_NAME}-${VERSION}.tgz