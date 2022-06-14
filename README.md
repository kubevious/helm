# Kubevious Helm Charts
**Kubevious** is an app-centric assurance, validation, and introspection platform for Kubernetes. It helps running modern Kubernetes applications without disasters and costly outages by continuously validating application manifests, cluster state and configuration. Kubevious detects errors(*typos, misconfigurations, conflicts, inconsistencies*) and violations of best practices. Kubevious' unique app-centric user interface delivers intuitive insight, introspection and troubleshooting tools for cloud-native applications. Right out of the box. Kubevious operates inside the cluster with user interface accessible as a web app. It only takes a couple of minutes to get Kubevious up and running for existing production applications.

For more information refer to the root repository: https://github.com/kubevious/kubevious

## Prerequisites

- Kubernetes v1.13 or higher
- Helm v3.2 or higher

## Installation 

First create a namespace:

```sh
kubectl create namespace kubevious
```

Add Kubevious repository and install the Helm chart:
```sh
helm repo add kubevious https://helm.kubevious.io
helm upgrade --atomic -i kubevious kubevious/kubevious --version 1.0.7 -n kubevious 
```

## Accessing Kubevious
Kubevious runs within your cluster. Upon successful completion of helm chart installation, you will see commands to access Kubevious UI. There are two ways to access Kubevious UI. 

### Option 1. Access using port forwarding
The easiest but not most convenient method. Wait few seconds before pods are up and running. Setup port forwarding:

```sh
kubectl port-forward $(kubectl get pods -n kubevious -l "app.kubernetes.io/component=kubevious-ui" -o jsonpath="{.items[0].metadata.name}") 8080:80 -n kubevious  
```
Access from browser: http://localhost:8080

### Option 2. Expose using Ingress
Enable Ingress deployment using dedicated value parameters. See full list of [helm chart values](#configuration) to cofigure Ingress parameters.

```sh
helm upgrade --atomic -i -n kubevious \
    --version 1.0.3 \
    --set ingress.enabled=true \
    kubevious kubevious/kubevious
```

## Uninstalling the Chart
Undeploy from cluster:

```sh
helm uninstall kubevious -n kubevious
```

**IMPORTANT:** As requested by the community, now Kubevious Helm charts generate random MySQL root and user passwords. The Helm uninstall leaves behind the MySQL persistent volume. The same volume will be mounted if Kubevious is reinstalled into the same namespace using the same release name. That creates a big problem because Helm chart will generate new passwords for the backend to connect to MySQL, but the connection would fail because the mounted volume is initialized using the password generated using the initial installation. There are few solutions to this:

1. Delete the PersistentVolumeClain after *helm uninstall*:
```sh
$ kubectl delete pvc data-kubevious-mysql-0 -n kubevious
```

2. Install Kubevious providing your own root and user passwords. See *mysql.root_password* and *mysql.db_password* configuration values below.

3. Bit more complicated way is to update passwords in *kubevious-mysql-secret* and *kubevious-mysql-secret-root* Kubernetes secrets. Though wouldn't recommend going that route.

## Anonymous Analytics

A two-way feedback mechanism was added to Kubevious. It includes version checks, news updates, useful hints and tips,  and reporting of errors, cluster size metrics, and internal time counters. Participants can also see their clusters on a https://worldvious.io leaderboard map. Location is anonymized to the nearest city/zip. No IP address is stored or logged. We calculate the SHA256 hash of the IP address and use it as a key in the backend. If, for some reason, you do not want to participate, please see details of reporting [configurations](#configuration) parameters and instructions to opt-out (it's super easy).

## Scale Setup

When running Kubevious in large Kubernetes clusters with lots of Nodes, Pods, Events or other resources, consider providing adequate resources to following chart settings:

- collector.resources.*
- collector.v8MaxOldSpace
- parser.resources.*
- parser.v8MaxOldSpace

For details see https://nodejs.org/docs/latest-v14.x/api/cli.html#cli_useful_v8_options

## Configuration

The following table lists the configurable parameters of the kubevious chart and their default values.

| Value                               | Description                                                  | Default                                      |
| ----------------------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| nameOverride                        | Overrides the *app.kubernetes.io/name* label value           |                                              |
| fullnameOverride                    | Overrides name of the app                                    |                                              |
| ingress.enabled                     | Whether to expose Kubevious using Ingress gateway.           | false                                        |
| ingress.annotations                 | Dictionary of Ingress annodations.                           | `{kubernetes.io/ingress.allow-http: "true"}` |
| ingress.hosts                       | Array of hosts and paths for ingress                         | `[{host: "", paths: [{ path: "", pathType: ImplementationSpecific }] }`]               |
| ingress.tls                         | Array of ingress tls configurations. Fields are *hosts* array and *secretName* |                                              |
| backend.podAnnotations            | Backend pod annotations                            |  |
| backend.image.pullPolicy          | Backend PodSpec pullPolicy                         | IfNotPresent                                 |
| backend.image.imagePullSecrets    | Backend PodSpec imagePullSecrets                   |                                              |
| backend.service.type              | Backend type of service                            | ClusterIP                                    |
| backend.service.port              | Backend port of service                            | 4000                                         |
| backend.resources.requests.cpu    | Backend request CPU                                | 100m                                         |
| backend.resources.requests.memory | Backend request Memory                             | 200Mi                                        |
| backend.resources.limits.cpu      | Backend limit CPU                                  |                                              |
| backend.resources.limits.memory   | Backend limit Memory                               |                                              |
| backend.podSecurityContext        | Backend PodSpec securityContext                    |                                              |
| backend.nodeSelector              | Backend PodSpec nodeSelector                       |                                              |
| backend.tolerations               | Backend PodSpec tolerations                        |                                              |
| backend.affinity                  | Backend PodSpec affinity                           |                                              |
| backend.log.level                 | Backend log level. Values are: *error, warn, info, verbose, debug, silly* | Info |
| collector.podAnnotations            | Collector pod annotations                            |                                              |
| collector.image.pullPolicy          | Collector PodSpec pullPolicy                         | IfNotPresent                                 |
| collector.image.imagePullSecrets    | Collector PodSpec imagePullSecrets                   |                                              |
| collector.service.type              | Collector type of service                            | ClusterIP                                    |
| collector.service.port              | Collector port of service                            | 4000                                         |
| collector.resources.requests.cpu    | Collector request CPU                                | 100m                                         |
| collector.resources.requests.memory | Collector request Memory                             | 200Mi                                        |
| collector.resources.limits.cpu      | Collector limit CPU                                  |                                              |
| collector.resources.limits.memory   | Collector limit Memory                               |                                              |
| collector.v8MaxOldSpace             | Collector V8 old memory section (in megabytes)       |                                              |
| collector.podSecurityContext        | Collector PodSpec securityContext                    |                                              |
| collector.nodeSelector              | Collector PodSpec nodeSelector                       |                                              |
| collector.tolerations               | Collector PodSpec tolerations                        |                                              |
| collector.affinity                  | Collector PodSpec affinity                           |                                              |
| collector.log.level                 | Collector log level. Values are: *error, warn, info, verbose, debug, silly* | Info |
| guard.podAnnotations            | Guard pod annotations                            |                                              |
| guard.image.pullPolicy          | Guard PodSpec pullPolicy                         | IfNotPresent                                 |
| guard.image.imagePullSecrets    | Guard PodSpec imagePullSecrets                   |                                              |
| guard.service.type              | Guard type of service                            | ClusterIP                                    |
| guard.service.port              | Guard port of service                            | 4000                                         |
| guard.resources.requests.cpu    | Guard request CPU                                | 100m                                         |
| guard.resources.requests.memory | Guard request Memory                             | 200Mi                                        |
| guard.resources.limits.cpu      | Guard limit CPU                                  |                                              |
| guard.resources.limits.memory   | Guard limit Memory                               |                                              |
| guard.v8MaxOldSpace             | Guard V8 old memory section (in megabytes)       |                                              |
| guard.podSecurityContext        | Guard PodSpec securityContext                    |                                              |
| guard.nodeSelector              | Guard PodSpec nodeSelector                       |                                              |
| guard.tolerations               | Guard PodSpec tolerations                        |                                              |
| guard.affinity                  | Guard PodSpec affinity                           |                                              |
| guard.log.level                 | Guard log level. Values are: *error, warn, info, verbose, debug, silly* | Info |
| parser.podAnnotations               | Parser pod annotations                            |                                              |
| parser.image.pullPolicy          | Parser PodSpec pullPolicy                         | IfNotPresent                                 |
| parser.image.imagePullSecrets    | Parser PodSpec imagePullSecrets                   |                                              |
| parser.service.type              | Parser type of service                            | ClusterIP                                    |
| parser.service.port              | Parser port of service                            | 4000                                         |
| parser.resources.requests.cpu    | Parser request CPU                                | 100m                                         |
| parser.resources.requests.memory | Parser request Memory                             | 200Mi                                        |
| parser.resources.limits.cpu      | Parser limit CPU                                  |                                              |
| parser.resources.limits.memory   | Parser limit Memory                               |                                              |
| parser.v8MaxOldSpace             | Parser V8 old memory section (in megabytes)       |                                              |
| parser.podSecurityContext        | Parser PodSpec securityContext                    |                                              |
| parser.nodeSelector              | Parser PodSpec nodeSelector                       |                                              |
| parser.tolerations               | Parser PodSpec tolerations                        |                                              |
| parser.affinity                  | Parser PodSpec affinity                           |                                              |
| parser.log.level | Parser backend log level. Values are: *error, warn, info, verbose, debug, silly* | Info |
| parser.serviceAccount.create | Indicates whether a service account should be created for Parser | true |
| parser.serviceAccount.annotations | Annotations to add to Parser service account |                                              |
| parser.serviceAccount.name | The name of the service account to use. If not and create is true, a name is generated |                                              |
| parser.serviceAccount.skipRoleBinding | Skip creation of RoleBinding and Role for Parser. You would have to create a RoleBinding and Role manually and allow Kubernetes API access for Parser ServiceAccount. | false |
| ui.podAnnotations            | UI pod annotations                            |                                              |
| ui.image.pullPolicy          | UI PodSpec pullPolicy                         | IfNotPresent                                 |
| ui.image.imagePullSecrets    | UI PodSpec imagePullSecrets                   |                                              |
| ui.service.type              | UI type of service                            | ClusterIP                                    |
| ui.service.port              | UI port of service                            | 80                                        |
| ui.resources.requests.cpu    | UI request CPU                                | 25m                                        |
| ui.resources.requests.memory | UI request Memory                             | 50Mi                                        |
| ui.resources.limits.cpu      | UI limit CPU                                  |                                              |
| ui.resources.limits.memory   | UI limit Memory                               |                                              |
| ui.podSecurityContext        | UI PodSpec securityContext                    |                                              |
| ui.nodeSelector              | UI PodSpec nodeSelector                       |                                              |
| ui.tolerations               | UI PodSpec tolerations                        |                                              |
| ui.affinity                  | UI PodSpec affinity                           |                                              |
| mysql.external.enabled | Indicates whether an existing MySQL database should be used. When enabled a new MySQL database would not be deployed. | false |
| mysql.external.host | Host for external MySQL server | |
| mysql.external.port | Port for external MySQL server | |
| mysql.external.database | Database name for external MySQL server. The database should be manually created. | |
| mysql.external.user | User name. User should have access to the database specified above. | |
| mysql.external.password | Password. | |
| mysql.db_name | MySQL database name | kubevious |
| mysql.db_user | MySQL database user | kubevious |
| mysql.generate_passwords | Indicates whether a random password should be generated for root and kubevious users | false |
| mysql.db_password | MySQL database password | "kubevious" or a random password if generate_passwords is set  |
| mysql.root_password | MySQL root user password | "kubevious" or a random password if generate_passwords is set |
| mysql.persistence.enabled | Allows disabling of persistence | true |
| mysql.persistence.accessMode | MySQL persistent volume access mode | ReadWriteOnce |
| mysql.persistence.size | MySQL persistent volume size | 20Gi |
| mysql.persistence.storageClass | MySQL persistent volume storage class name |  |
| mysql.image.pullPolicy          | MySQL PodSpec pullPolicy                         | IfNotPresent                                 |
| mysql.image.imagePullSecrets    | MySQL PodSpec imagePullSecrets                   |                                              |
| mysql.service.type              | MySQL type of service                            | ClusterIP                                    |
| mysql.service.port              | MySQL port of service                            | 3306                                    |
| mysql.resources.requests.cpu    | MySQL request CPU                                | 250m                                       |
| mysql.resources.requests.memory | MySQL request Memory                             | 1000Mi                                      |
| mysql.resources.limits.cpu      | MySQL limit CPU                                  |                                              |
| mysql.resources.limits.memory   | MySQL limit Memory                               |                                              |
| mysql.podAnnotations            | MySQL pod annotations                            |                                              |
| mysql.podSecurityContext        | MySQL PodSpec securityContext                    |                                              |
| mysql.nodeSelector              | MySQL PodSpec nodeSelector                       |                                              |
| mysql.tolerations               | MySQL PodSpec tolerations                        |                                              |
| mysql.affinity                  | MySQL PodSpec affinity                           ||
| redis.image.pullPolicy          | Redis PodSpec pullPolicy                         | IfNotPresent                                 |
| redis.image.imagePullSecrets    | Redis PodSpec imagePullSecrets                   |                                              |
| redis.service.type              | Redis type of service                            | ClusterIP                                    |
| redis.service.port              | Redis port of service                            | 6379                                    |
| redis.resources.requests.cpu    | Redis request CPU                                | 100m                                       |
| redis.resources.requests.memory | Redis request Memory                             | 128Mi                                      |
| redis.resources.limits.cpu      | Redis limit CPU                                  |                                              |
| redis.resources.limits.memory   | Redis limit Memory                               |                                              |
| redis.podAnnotations            | Redis pod annotations                            |                                              |
| redis.podSecurityContext        | Redis PodSpec securityContext                    |                                              |
| redis.nodeSelector              | Redis PodSpec nodeSelector                       |                                              |
| redis.tolerations               | Redis PodSpec tolerations                        |                                              |
| redis.affinity                  | Redis PodSpec affinity                           ||
| worldvious.opt_out_version_check | Disables version check. As a part of the version check, Kubevious deployments are added to the leaderboard at https://worldvious.io. Reporting is anonymized to the nearest city/zip. No IP address is stored or logged. We calculate the SHA256 hash of the IP address and use it as a key. As a part of this request, we also added news notification and a feedback request mechanism. | false |
| worldvious.opt_out_error_report | Disables automatic exception and error reporting.            | false |
| worldvious.opt_out_counters_report | Disables periodic reporting of cluster metrics, such as: number of nodes, pods, ingresses, configmaps, etc. The number of pods and nodes would appear on the https://worldvious.io leaderboard. Those are the same counters you would see in the console log of kubevious and parser pods. | false |
| worldvious.opt_out_metrics_report | Disables periodic reporting of internal time metrics. In conjunction with counters reporting, this would help identify internal bottlenecks and improve overall performance.  Those are the same metrics you would see in the console log of kubevious and parser pods. | false |
| worldvious.opt_out_all | Opt out from all of the above reportings. | false |

