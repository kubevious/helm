# Setting up Kubernetes Ingress

## Digital Ocean
```sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm install ingress stable/nginx-ingress --set controller.publishService.enabled=true
```

