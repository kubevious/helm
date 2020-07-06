# Kubevious Helm Charts
**Kubevious** brings clarity and safety to Kubernetes. Kubevious renders all configurations relevant to the application in one place. That saves a lot of time from operators, enforcing best practices, eliminating the need for looking up settings and digging within selectors and labels.

For more information refer to the root repository: https://github.com/kubevious/kubevious

## Prerequisites
- Kubernetes v1.13 or higher
- Helm v3.x

## Installing the Chart using Helm v3.x
If using Helm version lower than v3.2 first create a namespace:

```sh
kubectl create namespace kubevious
```
Deploy using Helm:

```sh
helm repo add kubevious https://helm.kubevious.io
helm upgrade --atomic -i kubevious kubevious/kubevious --version 0.6.36 -n kubevious 
```

## Accessing Kubevious
Kubevious runs within your cluster. There are two ways to access Kubevious UI. 

### Option 1. Access using port forwarding
The easiest but not most convenient method. Wait few seconds before pods are up and running. Setup port forwarding:

```sh
kubectl port-forward $(kubectl get pod -l k8s-app=kubevious-ui -n kubevious -o jsonpath="{.items[0].metadata.name}") 3000:80 -n kubevious
```
Access from browser: http://localhost:3000

### Option 2. Expose using Ingress
Enable Ingress deployment using dedicated value parameters. See full list of [helm chart values](#helm-chart-values). You will also find other parameters to setup static ip, SSL certificate and domain name.

```sh
helm upgrade --atomic -i -n kubevious \
    --version 0.6.36 \
    --set ingress.enabled=true \
    kubevious kubevious/kubevious
```

## Uninstalling the Chart
Undeploy from cluster:

```sh
helm delete kubevious -n kubevious
```

## Installing the Chart using Helm v2.x
TBD

## Upgrading from non-Helm version

If you are upgrading from version deployed using kubectl apply, first cleanup existing deployment:

```sh
kubectl delete namespace kubevious
kubectl delete clusterrole kubevious
kubectl delete clusterrolebinding kubevious
```

## Configuration
The following table lists the configurable parameters of the kubevious chart and their default values.

| Value                  | Description                                                                                                                                                                  | Default       |
| ---------------------- |------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| mysql.storageClass     | Storage class applied to MySQL persistent volume claim.                                                                                                                      |               | 
| ingress.enabled        | Whether to expose Kubevious using ingress gateway.                                                                                                                           | false         | 
| ingress.class          | Ingress class name.                                                                                                                                                          | false         | 
| ingress.domain         | Domain name to be used with ingress gateway.                                                                                                                                 |               | 
| ingress.staticIpName   | Name of static ip object used with the ingress gateway.                                                                                                                      |               | 
| ingress.tlsSecretName  | Enables TLS configuration. Specifies the name of Kubernetes secret used in TLS                                                                                               |               | 
| ingress.annotations    | Additional annotations to be applied to the ingress gateway.                                                                                                                 |               | 
| ingress.labels         | Additional metadata labels to be applied to the ingress gateway.                                                                                                             |               | 
| cluster.domain         | Overrides the default Kubernetes cluster domain name.                                                                                                                        | cluster.local | 
| provider               | Environment where Kubevious is deployed. Possible values are: **gke**, **eks**, **aks**, **doks**. Use **none** for any other cases including on-prem.                       | none          | 

