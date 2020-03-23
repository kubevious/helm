# Kubevious Helm Charts

## Installing
Deploy using Helm v3.x:
```sh
kubectl create namespace kubevious

helm upgrade --wait --atomic -i -n kubevious kubevious ./helm
```

Starting from Helm v3.2 it will not be required to create a namespace manually:
```sh
helm upgrade --wait --atomic -i -n kubevious kubevious ./helm
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

