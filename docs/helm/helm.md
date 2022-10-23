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