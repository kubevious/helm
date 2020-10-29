#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

echo "RUNNIG HELM LINT..."
helm lint kubernetes/

echo "RUNNIG HELM VERIFY..."
# helm verify kubernetes/

