#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
MY_DIR="$(dirname $MY_PATH)"

cd $MY_DIR

CURRENT_CONTEXT=$(kubectl config current-context)
echo "Current context is: ${CURRENT_CONTEXT}"
echo "Will setup Kubevious MySQL credentials now"
read -r -p "Do you want to continue?(y/N) " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        echo "Aborted"
        exit 1;
        ;;
esac

kubectl delete pod kubevious-mysql-credentials-setup -n kubevious

kubectl apply -f utils/setup-credentials-pod.yaml

kubectl get pods -n kubevious

sleep 10

kubectl get pods -n kubevious

kubectl logs kubevious-mysql-credentials-setup -n kubevious