# Kustomize

[Kustomize](https://kustomize.io/) is a Kubernetes native configuration management based on Overlays.

- Bundled with kubectl, but not all the features are available
- It's better install the full version if you use it intensively (like plugins)
- It only output rendered YAML, you have to apply it with another command
- Can be used on top of Helm

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

For this DEMO, we created a `demo` folder and a `base` folder inside of it, where we created the yaml files to deploy the application.

Now add a `kustomization.yaml` file along the other `yaml`s:

```bash
cat > kustomization.yaml << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: gowebapp

resources:
- app-deployment.yaml
- app-service.yaml
- mysql-deployment.yaml
- mysql-secret.yaml
- mysql-service.yaml
EOF
```

It is easy to generate the final result using the kustomize` command:

```bash
kustomize build
# Same as kubectl kustomize base
```
```yaml title="output"
apiVersion: v1
data:
  password: cm9vdHBhc3N3ZA==
kind: Secret
metadata:
  name: mysql
type: Opaque
---
apiVersion: v1
kind: Service
metadata:
  labels:
    run: gowebapp
  name: gowebapp
spec:
  ports:
  - port: 9000
    targetPort: 9000
  selector:
    run: gowebapp
  type: LoadBalancer
---
apiVersion: v1
kind: Service
...
```

## Add an `overlay` for the `dev` environment

Overlays are variations on the original yaml that you apply "on top" of the base. Configuration of overlays are also done in a `kustomization.yaml` file in a different folder.

First we have to create a new folder for overlays:

```bash
cd ..
mkdir -p overlays/dev overlays/stg
```

Now the folder structure should be like:

```bash
.
├── base
│   ├── app-deployment.yaml
│   ├── app-service.yaml
│   ├── kustomization.yaml
│   ├── mysql-deployment.yaml
│   ├── mysql-secret.yaml
│   └── mysql-service.yaml
└── overlays
    ├── dev
    └── stg
```

Let's create an Overlay to ensure the `dev` version is deploying inside the `dev` namespace:

```bash
cat <<EOF >overlays/dev/kustomization.yaml
resources:
- ./../../base

namespace: dev
namePrefix: dev-
EOF
```

We can generate the resulting yaml for the `dev` cluster:

```bash
kustomize build overlays/dev
```
```yaml title="output"
...
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: gowebapp-mysql
    tier: backend
  name: dev-gowebapp-mysql
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      run: gowebap
...
```

Here, the `metadata.name` and `metadata.namespace` were updated with our new values.

But the `dev` namespace actually does not exist in our cluster. 

We can have Kustomize create it by adding a new `namespace` resource:

```bash
cat <<EOF >overlays/dev/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
EOF
```

Then we include this new resource to our kustomization:

```bash
cat <<EOF >overlays/dev/kustomization.yaml
resources:
- ./../../base
- namespace.yaml

namespace: dev
namePrefix: dev-
EOF
```

When re-running the kustomize command, we now also create the namespace:

```bash
kustomize build overlays/dev
```
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
---
apiVersion: v1
data:
...
```

All this is getting better, but it's common practices to add some `labels` to the resources to describe their role, owner or environment.

We can fix that by overriding the labels with a `commonLabels` keyword :

```bash
cat <<EOF >overlays/dev/kustomization.yaml
resources:
- ./../../base
- namespace.yaml

namespace: dev
namePrefix: dev-

commonLabels:
  app: gowebapp
  owner: prune
  version: v1
  environment: dev
EOF
```

As expected we have new labels:

```bash
kustomize build overlays/dev
```
```yaml hl_lines="5 8"
apiVersion: v1
kind: Namespace
metadata:
  labels:
    app: gowebapp
    environment: dev
    owner: prune
    version: v1
  name: dev
---
apiVersion: v1
data:
  password: cm9vdHBhc3N3ZA==
kind: Secret
metadata:
  labels:
    app: gowebapp
    environment: dev
    owner: prune
    version: v1
  name: dev-mysql
  namespace: dev
type: Opaque
...
```

## add an overlay for staging

We can do the same for staging :

```bash
cat <<EOF >overlays/stg/kustomization.yaml
resources:
- ./../../base
- namespace.yaml

namespace: stg
namePrefix: stg-

commonLabels:
  app: gowebapp
  owner: prune
  version: v1
  environment: stg
EOF

cat <<EOF >overlays/stg/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: stg
EOF
```