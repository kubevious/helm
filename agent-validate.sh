#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

echo "RUNNIG HELM LINT..."
helm lint agent/

echo "CLEANUP..."
rm -rf output-agent

echo "RUNNIG TEMPLATE DEFAULT..."
helm template kubevious-agent ./agent --debug -n kubevious-agent --output-dir output-agent/default

echo "RUNNIG TEMPLATE LEGACY-MINIMAL..."
helm template kubevious-agent ./agent --debug -n kubevious-agent -f agent-dev/legacy-minimal.yaml --output-dir output-agent/legacy-minimal

echo "RUNNIG TEMPLATE EXISTING-SERVICE-ACCOUNT..."
helm template kubevious-agent ./agent --debug -n kubevious-agent -f agent-dev/existing-service-account.yaml --output-dir output-agent/existing-service-account

