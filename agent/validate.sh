#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

echo "RUNNIG HELM LINT..."
helm lint chart/

echo "CLEANUP..."
rm -rf output

echo "RUNNIG TEMPLATE DEFAULT..."
helm template kubevious-agent ./chart --debug -n kubevious-agent --output-dir output/default

echo "RUNNIG TEMPLATE EXISTING-SERVICE-ACCOUNT..."
helm template kubevious-agent ./chart --debug -n kubevious-agent -f overrides/existing-service-account.yaml --output-dir output/existing-service-account

