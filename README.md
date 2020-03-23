## Summary of Changes

#### Major Changes:

* Resolved critical issue causing a crash loop if HorizontalPodAutoScaler refers to an invalid Deployment.
* Enhanced parcer to handle errors gracefully.

## Deployment
Deploy using Helm:
```sh
kubectl create namespace kubevious

helm upgrade --wait --install  --atomic --namespace "kubevious" release_name ./helm
```
You need to make sure you have helm installed in your machine.


## Accessing UI
Setup port forwarding:
```sh
kubectl port-forward $(kubectl get pod -l k8s-app=kubevious-ui -n kubevious -o jsonpath="{.items[0].metadata.name}") 3000:3000 -n kubevious
```
Access from browser: http://localhost:3000

