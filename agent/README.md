# Kubevious Agent Helm Charts
**Kubevious Agent** reports configuration from inside the cluster to Kubevious SaaS (https://portal.kubevious.io).

## Prerequisites

- Kubernetes v1.13 or higher
- Helm v3.2 or higher

## Installation 

1. Create a namespace:

```sh
kubectl create namespace kubevious-agent
```

2. Create token secret `kubevious-token`. Specific instructions with token data value is available in cluster editor.

```sh
kubectl create secret generic kubevious-token -n kubevious-agent \
    --from-literal=key=<data-from-kubevious-portal-cluster-editor> \
    --dry-run=client -o yaml |
    kubectl apply -f -
```

3. Add repository
```sh
helm repo add kubevious https://helm.kubevious.io
```

4. Install the agent chart
```sh
helm upgrade --atomic -i -n kubevious-agent kubevious-agent kubevious/kubevious-agent
```


## Configuration

The following table lists the configurable parameters of the kubevious chart and their default values.

| Value                               | Description                                                  | Default                                      |
| ----------------------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| nameOverride                        | Overrides the *app.kubernetes.io/name* label value           |                                              |
| fullnameOverride                    | Overrides name of the app                                    |                                              |
| parser.podAnnotations               | Kubevious parser pod annotations                            |                                              |
| parser.image.pullPolicy          | Kubevious parser PodSpec pullPolicy                         | IfNotPresent                                 |
| parser.image.imagePullSecrets    | Kubevious parser PodSpec imagePullSecrets                   |                                              |
| parser.resources.requests.cpu    | Kubevious parser request CPU                                | 100m                                         |
| parser.resources.requests.memory | Kubevious parser request Memory                             | 200Mi                                        |
| parser.resources.limits.cpu      | Kubevious parser limit CPU                                  |                                              |
| parser.resources.limits.memory   | Kubevious parser limit Memory                               |                                              |
| parser.podSecurityContext        | Kubevious parser PodSpec securityContext                    |                                              |
| parser.nodeSelector              | Kubevious parser PodSpec nodeSelector                       |                                              |
| parser.tolerations               | Kubevious parser PodSpec tolerations                        |                                              |
| parser.affinity                  | Kubevious parser PodSpec affinity                           |                                              |
| parser.log.level | Parser backend log level. Values are: *error, warn, info, verbose, debug, silly* | Info |
| parser.serviceAccount.create | Indicates whether a service account should be created for Kubevious parser | true |
| parser.serviceAccount.annotations | Annotations to add to Kubevious parser service account |                                              |
| parser.serviceAccount.name | The name of the service account to use. If not and create is true, a name is generated |                                              |
| parser.serviceAccount.legacyMinimal | The legacy permission mode where only minimal read-only access to the cluster is allowed. When turned on you will not be able to see and validate any custom CRDs. See [below](#kubernetes-secret-sanitization) if you want to learn how how sensitive data is sanitized. | false |

## Detailed Notes

### Kubernetes Secret Sanitization
Data from Kubernetes secrets is sanitized and does not leave the cluster. Keys of data are maintained but data is completely removed. Maintaining information about keys in secret allows validation of structure of secrets and show how things are mapped to environment variables and volume mounts. Below is the example of Secret reported to Kubevious SaaS:
```yaml
kind: Secret
apiVersion: v1
metadata:
  name: default-token-w2656
data:
  ca.crt: <null-instead-of-the-data>
  token: <null-instead-of-the-data>
```
If you want to learn more how sanitization works, please see the following code snippet below. Search for the `_sanitizeSecret` function. It may take few seconds for github to scroll to the line of interest.
https://github.com/kubevious/parser/commit/1c3f19b781d6c22ccf4a4fa24bce10b514ea8150#diff-179652d03fa7d2a54b9fe88c99bd1e94bea9147b01b2b6616610a069244a348fR96-R104