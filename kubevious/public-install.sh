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

helm repo add kubevious https://helm.kubevious.io

helm repo update

kubectl create namespace kubevious

# --debug
helm upgrade --atomic -i \
    --version 0.8.15 \
    -n kubevious \
    --set worldvious.opt_out_all=save \
    kubevious kubevious/kubevious 