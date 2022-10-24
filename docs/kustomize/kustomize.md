# Kustomize

[Kustomize](https://kustomize.io/) is a Kubernetes native configuration management (templating).

- Bundled with kubectl, but not all the features are available
- It's better install the full version if you use it intensively
- It only output rendered YAML, you have to apply it with another command

## Install

Check [the official site](https://kubectl.docs.kubernetes.io/installation/kustomize/).

=== "Max OS X"

    ```bash
    brew install kustomize
    ```

=== "All OS"

    ```bash
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
    ```

=== "Golang install"

    ```bash
    GOBIN=$(pwd)/ GO111MODULE=on go install sigs.k8s.io/kustomize/kustomize/v4@latest
    ```

## Setup your project for Kustomize

Kustomize requires a `kustomization.yaml` file along other `yaml` file.

Here is the code to create a basic project:

```bash
mkdir myProject
cd myProject
mkdir -p base overlays/dev overlays/stg

k create deployment \
  --image=alpine:latest \
  --replicas=2 \
  -o yaml \
  --dry-run=client \
  simple-deployment > base/simple-deployment.yaml

k create service clusterip simple-service \
  --tcp=5678:8080 \
  -o yaml \
  --dry-run=client > base/simple-service.yaml

```

Now add a `kustomization` file:

```bash
cat > base/kustomization.yaml << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: myproject

resources:
- simple-deployment.yaml
- simple-service.yaml
EOF
```

It is easy to generate the final result using the kustomize` command:

```bash
kustomize build base
# Same as kubectl kustomize base
```
```yaml title="output"
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: simple-service
  name: simple-service
spec:
  ports:
  - name: 5678-8080
    port: 5678
    protocol: TCP
    targetPort: 8080
  selector:
    app: simple-service
  type: ClusterIP
status:
  loadBalancer: {}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: simple-deployment
  name: simple-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: simple-deployment
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: simple-deployment
    spec:
      containers:
      - image: alpine:latest
        name: alpine
        resources: {}
status: {}
```

As seen previously, the deployment and services are actually not fully working. Yes, they can be deployed, but some parameteres needs to be set to be a working app.

## Add an `overlay` for the `dev` environment

Overlays are variation on the original yaml that you apply "on top" of the base. Configuration of also done in a `kustomization.yaml` file.

Deploy the app in the DEV namespace :

```bash
cat <<EOF >overlays/dev/kustomization.yaml
resources:
- ./../../base

namespace: dev
namePrefix: dev-
EOF
```

Now the project is deployed in the right environment, but the `service` is not targetting the right deployment labels. We can fix that by overriding the labels with a `commonLabels` keyword :

```bash
cat <<EOF >overlays/dev/kustomization.yaml
resources:
- ./../../base

namespace: dev
namePrefix: dev-

commonLabels:
  app: simple-deployment
  owner: prune
  version: v1
EOF
```


## add an overlay for staging

Deploy the app in the STG namespace :

```bash
cat <<EOF >overlays/stg/kustomization.yaml
resources:
- ./../../base

namespace: stg
namePrefix: stg-

commonLabels:
  app: simple-deployment
  owner: prune
  version: v1
  environment: stg
EOF
```