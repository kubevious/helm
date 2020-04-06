# Development Help

```sh
helm template kubernetes \
    --namespace kubevious \
    --set ingress.enabled=true \
    --set ingress.domain=example.com \
    --set ingress.tls=true \
    --set ingress.tlsSecretName=kubevious-tls \
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