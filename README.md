# Kubevious Helm Charts
**Kubevious** brings clarity and safety to Kubernetes. Kubevious renders all configurations relevant to the application in one place. That saves a lot of time from operators, enforcing best practices, eliminating the need for looking up settings and digging within selectors and labels.

For more information refer to the root repository: https://github.com/kubevious/kubevious

## Prerequisites
- Kubernetes v1.13 or higher
- Helm v3.x

## Installing the Chart
If using Helm version lower than v3.2 first create a namespace:

```sh
kubectl create namespace kubevious
```
Deploy using Helm:

```sh
helm repo add kubevious https://helm.kubevious.io
helm upgrade --atomic -i kubevious kubevious/kubevious -n kubevious 
```

## Accessing Kubevious
Kubevious runs within your cluster. There are two ways to access Kubevious UI. 

### Option 1. Access using port forwarding
The easiest but not most convenient method. Wait few seconds before pods are up and running. Setup port forwarding:

```sh
kubectl port-forward $(kubectl get pod -l k8s-app=kubevious-ui -n kubevious -o jsonpath="{.items[0].metadata.name}") 3000:3000 -n kubevious
```
Access from browser: http://localhost:3000

### Option 2. Expose using Ingress
Enable Ingress deployment using dedicated value parameters. If you are running in cloud environment consider setting **provider** value to simplify ingress configuration. Also, check full list of [helm chart values](#helm-chart-values). You will also find other parameters to setup static ip, SSL certificate and domain name.

```sh
helm upgrade --atomic -i -n kubevious \
    --set ingress.enabled=true \ 
    kubevious kubevious/kubevious \
```

## Uninstalling the Chart
Undeploy from cluster:

```sh
helm delete kubevious -n namespace
```

## Upgrading from non-Helm version

If you are upgrading from version deployed using kubectl apply, first cleanup existing deployment:

```sh
kubectl delete namespace kubevious
kubectl delete clusterrole kubevious
kubectl delete clusterrolebinding kubevious
```

## Configuration
The following table lists the configurable parameters of the kubevious chart and their default values.


| Value                | Description                                 | Default    |
| -------------------- |---------------------------------------------|------------|
| provider             | Environment where Kubevious is deployed. Possible values are: **gke**, **eks**, **aks**, **doks**. Use **none** for any other cases including on-prem. | none       | 
| ingress.enabled      | Whether to expose Kubevious using ingress gateway.      |  false      | 
| ingress.domain       | Domain name to be used with ingress gateway.      |            | 
| ingress.staticIpName | Name of static ip object used with the ingress gateway.      |            | 
| ingress.annotations  | Additional annotations to be applied to the ingress gateway.      |            | 
