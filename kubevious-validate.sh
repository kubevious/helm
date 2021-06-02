#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

echo "RUNNIG HELM LINT..."
helm lint kubernetes/

echo "RUNNIG HELM LINT with DEPLOY IMAGE..."
docker run -ti --rm -v $(pwd):/apps kubevious/aws_cicd_deployer helm lint /apps/kubernetes

echo "RUNNIG HELM VERIFY..."
helm verify kubernetes/

