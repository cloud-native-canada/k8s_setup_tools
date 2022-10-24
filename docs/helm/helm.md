# Helm

[Helm](https://helm.sh/) is templating tool for yaml, aimed for Kubernetes.

Helm is used to create (or use) `packages` of you application called a `Chart`. Most Kubernetes applications like the CNCF apps provides a Helm chart with default values. It is then possible to tune the values to suite a special environment or special need.

Charts are available to be downloaded and used locally or directly from a remote URL or repository.

## Install

=== "Apple Mac OS X"

    ```bash
    brew install helm
    ```
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
helm repo add mysql-operator https://mysql.github.io/mysql-operator/
helm repo update
helm install my-mysql-operator mysql-operator/mysql-operator \
   --namespace mysql-operator --create-namespace



helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

```

The above command is deploying the `mysql` Operator:

```bash
k get pods -n mysql-operator
```
```bash title="output"
NAME                              READY   STATUS    RESTARTS   AGE
mysql-operator-76b8467d9c-bk9k8   1/1     Running   0          4m40s
```

With the Operator running it is possible to create a mysql database. Let's check the values avaiable to configure this new chart:

```bash
helm show values mysql-operator/mysql-innodbcluster
```
```bash title="output"
image:
  pullPolicy: IfNotPresent
  pullSecrets:
    enabled: false
    secretName:


credentials:
  root:
    user: root
#    password: sakila
    host: "%"

tls:
  useSelfSigned: false
#  caSecretName:
#  serverCertAndPKsecretName:
#  routerCertAndPKsecretName:

#serverVersion: 8.0.31
serverInstances: 3
routerInstances: 1
baseServerId: 1000


#podSpec:
#  containers:
#  - name: mysql
#    resources:
#      requests:
#        memory: "2048Mi"  # adapt to your needs
#        cpu: "1800m"      # adapt to your needs
#      limits:
#        memory: "8192Mi"  # adapt to your needs
#        cpu: "3600m"      # adapt to your needs


#serverConfig:
#  mycnf: |
...
```

The cart creates a 3 node cluster with 2G of memory and 1.8 CPU by default. This is too much for our cluster, so let's bring that down:

```bash
helm install my-mysql-innodbcluster mysql-operator/mysql-innodbcluster -n my-application \
  --version 2.0.7 \
  --set credentials.root.password="mypass" \
  --set tls.useSelfSigned=true \
  --set serverInstances=1 \
  --set routerInstances=1 \
  --set podSpec.containers[0].resources.requests.memory="10Mi" \
  --set podSpec.containers[0].resources.limits.memory="100Mi" \
  --set podSpec.containers[0].resources.requests.cpu="10m" \
  --set podSpec.containers[0].resources.limits.cpu="100m" \
  --create-namespace
```

### Validate which version is deployed

When helm deploy a Chart it keeps a trace in a `secret` so it can keep track. The `helm` CLI includes some commands that uses the secret to give informations of the status of the deployment. 

```bash
helm history
helm list
helm rollback
```

### View deployment values and yaml

The data inside the Helm `secret` is double encoded and gzipped:

```bash
k get secret xxx -o yaml | bas64 --decode | base64 --decode | gunzip
```