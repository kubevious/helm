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