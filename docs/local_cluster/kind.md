# Kind

- Local K8s cluster
- Official Kubernetes tool to create lightweight K8s clusters
- Support ingress / LB (with some tuning)
- Work with Docker and Podman (and rootless with some more sweat)

[https://kind.sigs.k8s.io/](https://kind.sigs.k8s.io/)

## Install

=== "Apple Mac OsX"

    ```bash title="OsX Install"
    brew install kind
    ```

=== "Linux"

    ```bash title="Linux Install"
    wget https://github.com/kubernetes-sigs/kind/releases/download/v0.15.0/kind-linux-amd64
    chmod 755 kind-linux-amd64

    mv kind-linux-amd64 /usr/local/bin/kind
    ```

=== "Windows"

    ```bash title="Windows Install"
    # TODO
    ```

## Setup

Use the Kind command `create cluster` to start a new cluster.

```bash
kind create cluster --help
```

You can list existing clusters too:

```bash
kind get clusters
```

## Usage

It's better to create a config file and create a cluster from it so you can re-use it or iterate some changes. 

Here's the config yaml file:

```yaml linenums="1" title="kind-dev.yaml"
--8<-- "docs/local_cluster/kind-dev.yaml"
```

!!! warning
    If you haven't done it already, create a new folder to store all the files we're creating.
    Refer to [the introduction](../index.md#setup) if you need help.

Then create the cluster from this file:

```bash
cat > kind-dev.yaml << EOF
--8<-- "docs/local_cluster/kind-dev.yaml"
EOF
```
```bash
kind create cluster --name=dev --config kind-dev.yaml -v9 --retain
```

Here's the regular logs when starting a Kind cluster:

```bash
enabling experimental podman provider
Creating cluster "dev" ...
 ✓ Ensuring node image (kindest/node:v1.24.4) 🖼
 ✓ Preparing nodes 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-dev"
```

You can check that everything is working. Each K8s node is actually a running `container`:

```bash
podman ps -a
```
```bash
CONTAINER ID  IMAGE                                                                                           COMMAND     CREATED        STATUS            PORTS                                        NAMES
6993dbdbf82b  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              3 minutes ago  Up 3 minutes ago  127.0.0.1:55210->6443/tcp                    dev-control-plane
dd461d2b9d4a  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              3 minutes ago  Up 3 minutes ago  0.0.0.0:3080->80/tcp, 0.0.0.0:3443->443/tcp  dev-worker
```

We can validate the state of the cluster too:

- k8s context

```bash
kubectl config current-context
```
```bash
kind-dev
```

- K8s cluster info

```bash
kubectl cluster-info
```
```bash
Kubernetes control plane is running at https://127.0.0.1:56141
CoreDNS is running at https://127.0.0.1:56141/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

- Running pods

```bash
kubectl get pods -A
```
```bash
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-lqcs6                     1/1     Running   0          4m6s
kube-system          coredns-6d4b75cb6d-xgbxk                     1/1     Running   0          4m6s
kube-system          etcd-dev-control-plane                       1/1     Running   0          4m18s
kube-system          kindnet-tjfzj                                1/1     Running   0          4m6s
kube-system          kindnet-vc66d                                1/1     Running   0          4m1s
kube-system          kube-apiserver-dev-control-plane             1/1     Running   0          4m18s
kube-system          kube-controller-manager-dev-control-plane    1/1     Running   0          4m18s
kube-system          kube-proxy-5kp6d                             1/1     Running   0          4m6s
kube-system          kube-proxy-dfczd                             1/1     Running   0          4m1s
kube-system          kube-scheduler-dev-control-plane             1/1     Running   0          4m18s
local-path-storage   local-path-provisioner-6b84c5c67f-csxg6      1/1     Running   0          4m6s
```

- All contexts

We can list all Kubernetes `context` using `kubectl`:

```bash
kubectl config  get-contexts
```
```bash
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
*         kind-dev    kind-dev    kind-dev
```

## Create a second cluster

```bash
cat > kind-stg.yaml << EOF
--8<-- "docs/local_cluster/kind-stg.yaml"
EOF
```
```bash
kind create cluster --name=stg --config kind-stg.yaml -v9 --retain
```

## Reboot

After a reboot, `podman` will be disabled. It is necessary to restart podman and restart your `kind` containers before the cluster is available:

```bash
podman machine start
podman start --all
```

## Next

Now that the Kind cluster is created, continue by [deploying some applications](../app_deployment.md).

Explore other K8s cluster options with [Minikube](options/minikube.md) !