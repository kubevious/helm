# Development Help

```sh
helm template kubernetes \
    --namespace kubevious \
    > kubevious-test.yaml
```

```sh
helm template kubernetes \
    --namespace kubevious \
    -f ../cicd-demo.git/helm/overrides.yaml \
    > kubevious-test.yaml
```


## Ingress Class
ingressClassName
https://kubernetes.io/docs/concepts/services-networking/ingress/#deprecated-annotation