# Kubevious Helm Charts

## Installing
Deploy using Helm v3.x:
```sh
kubectl create namespace kubevious

helm repo add kubevious https://helm.kubevious.io
helm upgrade --wait --atomic -i kubevious kubevious/kubevious -n kubevious 
```

Starting from Helm v3.2 it will not be required to create a namespace manually:
```sh
helm repo add kubevious https://helm.kubevious.io
helm upgrade --wait --atomic -i  kubevious kubevious/kubevious -n kubevious
```
## Uninstalling
Undeploy from cluster:
```sh
helm delete kubevious -n namespace
```


## Accessing UI
Setup port forwarding:
```sh
kubectl port-forward $(kubectl get pod -l k8s-app=kubevious-ui -n kubevious -o jsonpath="{.items[0].metadata.name}") 3000:3000 -n kubevious
```
Access from browser: http://localhost:3000

