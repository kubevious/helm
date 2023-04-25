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

# VERSION=0.9.13

# yq ".version = \"${VERSION}\"" -i chart/Chart.yaml 
# yq ".appVersion = \"${VERSION}\"" -i chart/Chart.yaml

echo "********************"
cat chart/Chart.yaml 
echo "********************"

VERSION=$(yq ".version" chart/Chart.yaml)
echo "VERSION: ${VERSION}"
echo "********************"

rm -f kubevious-*.tgz

helm package chart/ --version ${VERSION}

kubectl create namespace kubevious

# --debug
helm upgrade -i  \
    --atomic \
    -n kubevious \
    -f overrides/overrides.yaml \
    kubevious ./kubevious-${VERSION}.tgz
