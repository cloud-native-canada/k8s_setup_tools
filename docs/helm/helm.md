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
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Then we can check the `values` that can be tuned in the chart:

```bash
helm show values bitnami/mysql
```
```bash title="output"
server:
  ## Prometheus server container name
  ##
  enabled: true

  ## Use a ClusterRole (and ClusterRoleBinding)
  ## - If set to false - we define a RoleBinding in the defined namespaces ONLY
  ##
  ## NB: because we need a Role with nonResourceURL's ("/metrics") - you must get someone with Cluster-admin privileges to define this role for you, before running with this setting enabled.
  ##     This makes prometheus work - for users who do not have ClusterAdmin privs, but wants prometheus to operate on their own namespaces, instead of clusterwide.
  ##
  ## You MUST also set namespaces to the ones you have access to and want monitored by Prometheus.
  ##
  # useExistingClusterRoleName: nameofclusterrole

  ## namespaces to monitor (instead of monitoring all - clusterwide). Needed if you want to run without Cluster-admin privileges.
  # namespaces:
  #   - yournamespace

  name: server

  # sidecarContainers - add more containers to prometheus server
  # Key/Value where Key is the sidecar `- name: <Key>`
  # Example:
  #   sidecarContainers:
  #      webserver:
  #        image: nginx
  sidecarContainers: {}

  ## Prometheus server container image
  ##
  image:
    repository: quay.io/prometheus/prometheus
    tag: v2.39.1
    pullPolicy: IfNotPresent

  ## prometheus server priorityClassName
...
```

The chart creates mysql node with 256Mi of memory and 250m CPU by default.
This is too much for our cluster, so let's bring that down.

Using `helm template` it is possible to generate the final `yaml` before applying it:

```bash
helm template prometheus prometheus-community/prometheus \
  -n monitoring \
  --set alertmanager.enabled=false \
  --set persistentVolume.enabled=false \
  --set nodeExporter.enabled=true \
  --create-namespace
```

Then it is possible to deploy the chart using:

```bash
helm install prometheus prometheus-community/prometheus \
  -n monitoring \
  --set alertmanager.enabled=false \
  --set persistentVolume.enabled=false \
  --set nodeExporter.enabled=true \
  --create-namespace
```

Check the pod is running:

```bash
kubectl get pods -n monitoring
```
```bash title="output"
NAME                                             READY   STATUS    RESTARTS   AGE
prometheus-kube-state-metrics-774f8c7564-t5k9s   1/1     Running   0          110s
prometheus-node-exporter-slv85                   1/1     Running   0          110s
prometheus-pushgateway-5957cfcf57-xwczj          1/1     Running   0          110s
prometheus-server-6bd54674cc-x4lm6               1/2     Running   0          110s
```

### Updating a release

After some time the chart may be updated, a new version may come out, or we need to update some values.

Before an upgrade, it is better to check what the change will be. The [Helm-Diff](https://github.com/databus23/helm-diff) plugin can ease that:

```bash
helm plugin install https://github.com/databus23/helm-diff
```

Check the upgrade differences:

```bash
helm diff upgrade prometheus prometheus-community/prometheus \
  -n monitoring \
  --set alertmanager.enabled=false \
  --set persistentVolume.enabled=false \
  --set nodeExporter.enabled=true \
  --set server.resources.limits.memory="256Mi" \
  --set server.resources.limits.cpu="300m" 
```
```bash title="output" hl_lines="22 23"
monitoring, prometheus-server, Deployment (apps) has changed:
 # Source: prometheus/templates/server/deploy.yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: prometheus-server
    namespace: monitoring
  spec:
...
    replicas: 1
    template:
      spec:
        enableServiceLinks: true
        serviceAccountName: prometheus-server
        containers:
          - name: prometheus-server-configmap-reload
...

          - name: prometheus-server
            image: "quay.io/prometheus/prometheus:v2.39.1"
            imagePullPolicy: "IfNotPresent"
            args:
              - --storage.tsdb.retention.time=15d
              - --config.file=/etc/config/prometheus.yml
              - --storage.tsdb.path=/data
              - --web.console.libraries=/etc/prometheus/console_libraries
              - --web.console.templates=/etc/prometheus/consoles
              - --web.enable-lifecycle
            ports:
              - containerPort: 9090
            resources:
-             {}
+             limits:
+               cpu: 300m
+               memory: 256Mi
...
```

Re-deploy with changing some parameters:

```bash
helm upgrade prometheus prometheus-community/prometheus \
  -n monitoring \
  --set alertmanager.enabled=false \
  --set persistentVolume.enabled=false \
  --set nodeExporter.enabled=true \
  --set server.resources.limits.memory="256Mi" \
  --set server.resources.limits.cpu="300m" 
```

### Validate which version is deployed

When helm deploy a Chart it keeps a trace in a `secret`. The `helm` CLI includes some commands that uses the secret to give informations of the status of the deployment. 

List the deployed charts:
```bash
helm list -n monitoring
```
```bash title="output"
NAME    	  NAMESPACE     	REVISION	 UPDATED                    STATUS  	CHART      	        APP VERSION
prometheus	monitoring	2   2022-10-27 12:00:24.649426 -0400 EDT	deployed	prometheus-15.16.1	2.39.1
```

It is possible to check history revisions:

```bash
helm history prometheus -n monitoring
```
```bash title="output"
REVISION	UPDATED                 	STATUS    	CHART             	APP VERSION	DESCRIPTION
1       	Thu Oct 27 11:51:19 2022	superseded	prometheus-15.16.1	2.39.1     	Install complete
2       	Thu Oct 27 12:00:24 2022	deployed  	prometheus-15.16.1	2.39.1     	Upgrade complete
```

### View deployment values and yaml

Helm includes commands to see what was used for each revision:

```bash
helm get values prometheus -n monitoring
```
```bash title="output"
USER-SUPPLIED VALUES:
alertmanager:
  enabled: false
nodeExporter:
  enabled: true
persistentVolume:
  enabled: false
server:
  resources:
    limits:
      cpu: 300m
      memory: 256Mi
```

Or the generated manifest:

```bash
helm get manifest prometheus -n monitoring
```

The data inside the revision Helm `secret` is double encoded and gzipped:

```bash
kubectl -n monitoring get secret
```
```bash title="output"
NAME                               TYPE                 DATA   AGE
sh.helm.release.v1.prometheus.v1   helm.sh/release.v1   1      22m
sh.helm.release.v1.prometheus.v2   helm.sh/release.v1   1      13m
```

If you really like to dump the content for youself:

!!! warning

    The Secret's data also store some sensible values (secrets) 

```bash
kubectl get secret -n monitoring sh.helm.release.v1.prometheus.v2 \
  --output=go-template={{.data.release}}  | base64 --decode | base64 --decode | gunzip
```

Check out the [Lens UI](../interfaces/lens.md), which now has a plugin to dig into Helm releases !