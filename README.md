# Kubevious Helm Charts
**Kubevious** brings clarity and safety to Kubernetes. Kubevious renders all configurations relevant to the application in one place. That saves a lot of time from operators, enforcing best practices, eliminating the need for looking up settings and digging within selectors and labels.

For more information refer to the root repository: https://github.com/kubevious/kubevious

## Prerequisites
- Kubernetes v1.13 or higher
- Helm v3.1 or higher

## Installation 
First create a namespace:

```sh
kubectl create namespace kubevious
```

Add Kubevious repository and install the Helm chart:
```sh
helm repo add kubevious https://helm.kubevious.io
helm upgrade --atomic -i kubevious kubevious/kubevious --version 0.6.36 -n kubevious 
```

## Accessing Kubevious
Kubevious runs within your cluster. Upon successful completion of helm chart installation, you will see commands to access kubevious UI. There are two ways to access Kubevious UI. 

### Option 1. Access using port forwarding
The easiest but not most convenient method. Wait few seconds before pods are up and running. Setup port forwarding:

```sh
kubectl port-forward $(kubectl get pods -n kubevious -l "app.kubernetes.io/component=kubevious-ui" -o jsonpath="{.items[0].metadata.name}") 8080:80 -n kubevious  
```
Access from browser: http://localhost:8080

### Option 2. Expose using Ingress
Enable Ingress deployment using dedicated value parameters. See full list of [helm chart values](#helm-chart-values) to cofigure Ingress parameters.

```sh
helm upgrade --atomic -i -n kubevious \
    --version 0.6.36 \
    --set ingress.enabled=true \
    --set ui.service.type=NodePort \
    kubevious kubevious/kubevious
```

## Uninstalling the Chart
Undeploy from cluster:

```sh
helm delete kubevious -n kubevious
```

## Configuration
The following table lists the configurable parameters of the kubevious chart and their default values.

| Value               | Description                                                  | Default                                      |
| ------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| nameOverride        | Overrides the *app.kubernetes.io/name* label value           |                                              |
| fullnameOverride    | Overrides name of the app                                    |                                              |
| cluster.domain      | Overrides the default Kubernetes cluster domain name.        | cluster.local                                |
| ingress.enabled     | Whether to expose Kubevious using Ingress gateway.           | false                                        |
| ingress.annotations | Dictionary of Ingress annodations.                           | `{kubernetes.io/ingress.allow-http: "true"}` |
| ingress.hosts       | Array of hosts and paths for ingress                         | `[{host: "", paths: [ "" ] }`]               |
| ingress.tls         | Array of ingress tls configurations. Fields are *hosts* array and *secretName* |                                              |
|                     |                                                              |                                              |
|                     |                                                              |                                              |
|                     |                                                              |                                              |
|                     |                                                              |                                              |
|                     |                                                              |                                              |
|                     |                                                              |                                              |
|                     |                                                              |                                              |
| mysql.storageClass  | Storage class applied to MySQL persistent volume claim.      |                                              |
| provider            | Environment where Kubevious is deployed. Possible values are: **gke**, **eks**, **aks**, **doks**. Use **none** for any other cases including on-prem. | none                                         |

## Chart Configuration Changes
In version 0.7.15 Helm charts were redesigned. Consider following changes when upgrading from earlier version. 

Following configuration options were removed:
- provider
- ingress.class
- ingress.staticIpName

Following configuration values options were renamed:
- mysql.storageClass -> mysql.persistence.storageClass
- mysql.storage -> mysql.persistence.size
- mysql.db -> mysql.db_name
- mysql.user -> mysql.db_user
- mysql.pass -> mysql.db_password
- *.port -> *.service.port
- *.cpu -> *.resources.requests.cpu
- *.memory -> *.resources.requests.memory

Following Ingress annotations are not populated automatically. Use "ingress.annotations" instead. List of removed annotations:
- kubernetes.io/ingress.global-static-ip-name
- networking.gke.io/managed-certificates
- kubernetes.io/ingress.class
- kubernetes.io/tls-acme

Automatic creation of GKE managed certificate was removed.

MySQL password generation was added.
