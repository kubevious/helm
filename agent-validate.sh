#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

echo "RUNNIG HELM LINT..."
helm lint agent/

echo "RUNNIG TEMPLATE..."
helm template kubevious-agent ./agent --debug -n kubevious-agent -f agent-dev/overrides.yaml --output-dir output/
