# Kind

!!! important
    If you already have Docker-Desktop (Mac, Windows) or Docker Engine (Linux) installed and running, skip this step for the demo and go directly to [Deploying applications with kubectl](../app_deployment.md)

Kind is an amazing tool for running test clusters locally as it runs in a container which makes it lightweight and easy to run throw-away clusters for testing purposes.


- It can be used to deploy Local K8s cluster or for CI
- Support ingress / LB (with some tuning)
- Support deployment of multiple clusters / versions
- Supports deployment of single or multi node clusters

For more information, check out [https://kind.sigs.k8s.io/](https://kind.sigs.k8s.io/).

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

## Usage

To create a K8s cluster with `Kind` use the command:

```bash
kind create cluster --help
```

## Create a first kind cluster `dev`

In this guide we will run 2 clusters side by side `dev` and `stg`.


In order to have consitency over `kind` cluster configuration, create cluster by specifing a config file.
and settings such `k8s version` and etc,

Here's the config yaml file:

```yaml linenums="1" title="kind-dev.yaml"
--8<-- "docs/local_cluster/kind-dev.yaml"
```

Then create the cluster from this file:

```bash
cd ~/demo/
```

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
podman ps
```
```bash
CONTAINER ID  IMAGE                                                                                           COMMAND     CREATED        STATUS            PORTS                                        NAMES
6993dbdbf82b  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              3 minutes ago  Up 3 minutes ago  127.0.0.1:55210->6443/tcp                    dev-control-plane
dd461d2b9d4a  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              3 minutes ago  Up 3 minutes ago  0.0.0.0:3080->80/tcp, 0.0.0.0:3443->443/tcp  dev-worker
```

- See cluster up and running:

```
kubectl get nodes
```

```
NAME                STATUS   ROLES           AGE   VERSION
dev-control-plane   Ready    control-plane   11h   v1.24.4
dev-worker          Ready    <none>          11h   v1.24.4
```

!!! note
    You can see that our cluster has `control-plane` node and `worker` node.

- Verify k8s cluster status:

```bash
kubectl cluster-info
```

```bash
Kubernetes control plane is running at https://127.0.0.1:56141
CoreDNS is running at https://127.0.0.1:56141/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

- Check system Pods are up and running: 

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

## Create a second kind cluster stg

```bash
cat > kind-stg.yaml << EOF
--8<-- "docs/local_cluster/kind-stg.yaml"
EOF
```
```bash
kind create cluster --name=stg --config kind-stg.yaml -v9 --retain
```

- List clusters with `kind get`:

```
kind get clusters
```
**Output:**
```
dev
stg
```

!!! result
    Two K8s clusters `dev` and `stg` has been created


!!! note
    After a reboot, `podman` will be disabled. To recover podman and `kind` containers re-run following steps:
    
    ```bash
    podman machine start
    podman start --all
    ```

## Next

Now that the `Kind` clusters are created, continue by [deploying some applications](../app_deployment.md).