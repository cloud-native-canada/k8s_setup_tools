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
mkdir -p base overlay/dev overlay/stg overlay/prd
k 
```

Now add a `kustomization` file:

```bash
cat > base/kustomization.yaml << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: myproject

resources:
- deployment.yaml
- service.yaml
EOF

```