# Helm

[Helm](https://helm.sh/) is templating tool for yaml, aimed for Kubernetes.

Helm is used to create (or use) `packages` of you application called a `Chart`. Most Kubernetes applications like the CNCF apps provides a Helm chart with default values. It is then possible to tune the values to suite a special environment or special need.

Charts are available to be downloaded and used locally or directly from a remote URL or repository.

## Install

=== "Apple Mac OS X"

    ```bash
    brew install helm
    ```

=== "From Release page"

    Download the right version from [the Projet's Release page](https://github.com/helm/helm/releases).

## Usage

### Managing Remote Helm repository

```bash
helm repo list
```
```bash title="output"
NAME                	URL
stable              	https://charts.helm.sh/stable
hashicorp           	https://helm.releases.hashicorp.com
kiali               	https://kiali.org/helm-charts
couchbase           	https://couchbase-partners.github.io/helm-charts/
sumologic           	https://sumologic.github.io/sumologic-kubernetes-collection
cilium              	https://helm.cilium.io/
prometheus-community	https://prometheus-community.github.io/helm-charts
```

### Deploy an existing chart

To deploy a chart, the repository needs to be added (if not using a local chart):

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Then we can check the `values` that can be tuned in the chart:

```bash
helm show values bitnami/mysql
```
```bash title="output"
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  storageClass: ""

## @section Common parameters
...
image:
  registry: docker.io
  repository: bitnami/mysql
  tag: 8.0.31-debian-11-r0
...
## @section MySQL Primary parameters

primary:
  ## @param primary.name Name of the primary database (eg primary, master, leader, ...)
  ##
  name: primary
  ...
  resources:
    ## Example:
    ## limits:
    ##    cpu: 250m
    ##    memory: 256Mi
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 250m
    ##    memory: 256Mi
    requests: {}
...
```

The chart creates mysql node with 256Mi of memory and 250m CPU by default.
This is too much for our cluster, so let's bring that down.

Using `helm template` it is possible to generate the final `yaml` before applying it:

```bash
helm template my-mysql bitnami/mysql -n my-application \
  --set primary.resources.requests.memory="256Mi" \
  --set primary.resources.limits.memory="256Mi" \
  --set primary.resources.requests.cpu="100m" \
  --set primary.resources.limits.cpu="250m" \
  --create-namespace
```

Then it is possible to deploy the chart using:

```bash
helm install my-mysql bitnami/mysql -n my-application \
  --set primary.resources.requests.memory="256Mi" \
  --set primary.resources.limits.memory="256Mi" \
  --set primary.resources.requests.cpu="100m" \
  --set primary.resources.limits.cpu="250m" \
  --create-namespace
```

Check the pod is running:

```bash
kubectl get pods -n my-application
```
```bash title="output"
NAME         READY   STATUS    RESTARTS   AGE
my-mysql-0   1/1     Running   0          3m31s
```

Grab the `mysql` root and user password:

```bash
export MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace "my-application" my-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
export MYSQL_PASSWORD=$(kubectl get secret --namespace "my-application" my-mysql -o jsonpath="{.data.mysql-password}" | base64 -d)
```

### Updating a release

After some time the chart may be updated, a new version may come out, or we need to update some values.

Before an upgrade, it is better to check what the change will be. The [Helm-Diff](https://github.com/databus23/helm-diff) plugin can ease that:

```bash
helm plugin install https://github.com/databus23/helm-diff
```

Check the upgrade differences:

```bash
helm diff upgrade my-mysql bitnami/mysql -n my-application \
  --set primary.resources.requests.memory="256Mi" \
  --set primary.resources.limits.memory="256Mi" \
  --set primary.resources.requests.cpu="200" \
  --set primary.resources.limits.cpu="250m" \
  --set auth.rootPassword=$MYSQL_ROOT_PASSWORD \
  --set auth.password=$MYSQL_PASSWORD
```
```bash title="output" hl_lines="22 23"
my-application, my-mysql, StatefulSet (apps) has changed:
  # Source: mysql/templates/primary/statefulset.yaml
  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: my-mysql
    namespace: "my-application"
    labels:
      app.kubernetes.io/name: mysql
      helm.sh/chart: mysql-9.4.1
      app.kubernetes.io/instance: my-mysql
      app.kubernetes.io/managed-by: Helm
      app.kubernetes.io/component: primary
  spec:
    replicas: 1
...
            resources:
              limits:
                cpu: 250m
                memory: 256Mi
              requests:
-               cpu: 100m
+               cpu: 200
                memory: 256Mi
```

Re-deploy with changing some parameters:

```bash
helm upgrade my-mysql bitnami/mysql -n my-application \
  --set primary.resources.requests.memory="256Mi" \
  --set primary.resources.limits.memory="256Mi" \
  --set primary.resources.requests.cpu="200m" \
  --set primary.resources.limits.cpu="250m"
```

### Validate which version is deployed

When helm deploy a Chart it keeps a trace in a `secret`. The `helm` CLI includes some commands that uses the secret to give informations of the status of the deployment. 

List the deployed charts:
```bash
helm list -n my-application
```
```bash title="output"
NAME    	NAMESPACE     	REVISION	UPDATED                             	STATUS  	CHART      	APP VERSION
my-mysql	my-application	2       	2022-10-24 13:25:24.849222 -0400 EDT	deployed	mysql-9.4.1	8.0.31
```

It is possible to check history revisions:

```bash
helm history my-mysql -n my-application
```
```bash title="output"
REVISION	UPDATED                 	STATUS    	CHART      	APP VERSION	DESCRIPTION
1       	Mon Oct 24 13:18:45 2022	superseded	mysql-9.4.1	8.0.31     	Install complete
2       	Mon Oct 24 13:25:24 2022	deployed  	mysql-9.4.1	8.0.31     	Upgrade complete
```

### View deployment values and yaml

Helm includes commands to see what was used for each revision:

```bash
helm get values  my-mysql -n my-application
```
```bash title="output"
USER-SUPPLIED VALUES:
primary:
  resources:
    limits:
      cpu: 250m
      memory: 256Mi
    requests:
      cpu: 200m
      memory: 256Mi
```

Or the generated manifest:

```bash
helm get manifest  my-mysql -n my-application
```

The data inside the revision Helm `secret` is double encoded and gzipped:

```bash
kubectl -n my-application get secret
```
```bash title="output"
NAME                             TYPE                 DATA   AGE
my-mysql                         Opaque               2      14m
sh.helm.release.v1.my-mysql.v1   helm.sh/release.v1   1      14m
sh.helm.release.v1.my-mysql.v2   helm.sh/release.v1   1      7m22s
```

If you really like to dump the content for youself:

!!! warning

    The Secret's data also store some sensible values (secrets) 

```bash
kubectl get secret -n my-application sh.helm.release.v1.my-mysql.v2 \
  --output=go-template={{.data.release}}  | base64 --decode | base64 --decode | gunzip
```