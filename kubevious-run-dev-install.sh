#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

CURRENT_CONTEXT=$(kubectl config current-context)
echo "Current context is: ${CURRENT_CONTEXT}"
echo "Will install Kubevious now"
read -r -p "Do you want to continue?(y/N) " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        echo "Aborted"
        exit 1;
        ;;
esac

VERSION=0.0.8

yq w -i kubernetes/Chart.yaml version ${VERSION}
yq w -i kubernetes/Chart.yaml appVersion ${VERSION}

rm -f kubevious-*.tgz

helm package kubernetes/ --version ${VERSION}

kubectl create namespace kubevious

# --debug
helm upgrade -i  \
    --atomic \
    -n kubevious \
    -f dev/overrides.yaml \
    kubevious ./kubevious-${VERSION}.tgz