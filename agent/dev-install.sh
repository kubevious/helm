#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

CURRENT_CONTEXT=$(kubectl config current-context)
echo "Current context is: ${CURRENT_CONTEXT}"
echo "Will install Kubevious Agent now"
read -r -p "Do you want to continue?(y/N) " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        echo "Aborted"
        exit 1;
        ;;
esac

VERSION=0.0.1

yq ".version = \"${VERSION}\"" -i chart/Chart.yaml 
yq ".appVersion = \"${VERSION}\"" -i chart/Chart.yaml

echo "**********"
cat chart/Chart.yaml 
echo "**********"

rm -f kubevious-agent-*.tgz

helm package chart/ --version ${VERSION}

source ${MY_DIR}/runtime/key.sh

# Create namespace kubevious-agent
kubectl create namespace kubevious-agent

# Create Kubevious token secret
kubectl create secret generic kubevious-token -n kubevious-agent \
    --from-literal=key=${AGENT_KEY} \
    --dry-run=client -o yaml |
    kubectl apply -f -


# --debug
helm upgrade -i  \
    --atomic \
    -n kubevious-agent \
    -f overrides/overrides-install.yaml \
    kubevious-agent ./kubevious-agent-${VERSION}.tgz