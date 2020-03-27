# Setting up Kubernetes Ingress

## Digital Ocean
```sh
helm install ingress stable/nginx-ingress --set controller.publishService.enabled=true -n kubevious
```