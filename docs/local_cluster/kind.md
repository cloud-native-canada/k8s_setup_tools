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

```bash
kind create cluster --help
kind get clusters
```

## Usage

It's better to create a config file and create a cluster from it:

```yaml linenums="1" title="kind.yaml"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
kubeadmConfigPatches:
 - |
   apiVersion: kubeadm.k8s.io/v1beta2
   kind: ClusterConfiguration
   metadata:
 	name: config
   apiServer:
 	extraArgs:
   	"service-account-issuer": "kubernetes.default.svc"
   	"service-account-signing-key-file": "/etc/kubernetes/pki/sa.key"
networking:
 # the default CNI will not be installed if you enable it, usefull to install Cilium !
 disableDefaultCNI: false
nodes:
- role: control-plane
  image: kindest/node:v1.24.4@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98
- role: worker
  image: kindest/node:v1.24.4@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98
  extraPortMappings:
  - containerPort: 80
	hostPort: 3080
	listenAddress: "0.0.0.0"
  - containerPort: 443
	hostPort: 3443
	listenAddress: "0.0.0.0"
```

Then create the cluster

```bash
kind create cluster --name=demo --config kind.yaml -v9 --retain
```

Here's the regular logs when starting a Kind cluster:

```bash
enabling experimental podman provider
Creating cluster "demo" ...
 ✓ Ensuring node image (kindest/node:v1.24.4) 🖼
 ✓ Preparing nodes 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-demo"
```

You can check that everything is working. Each K8s node is actually a running `container`:

```bash
podman ps -a
CONTAINER ID  IMAGE                                                                                           COMMAND     CREATED        STATUS            PORTS                                        NAMES
6993dbdbf82b  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              3 minutes ago  Up 3 minutes ago  127.0.0.1:55210->6443/tcp                    demo-control-plane
dd461d2b9d4a  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              3 minutes ago  Up 3 minutes ago  0.0.0.0:3080->80/tcp, 0.0.0.0:3443->443/tcp  demo-worker

docker ps -a
CONTAINER ID  IMAGE                                                                                           COMMAND     CREATED        STATUS            PORTS                                        NAMES
6993dbdbf82b  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              4 minutes ago  Up 4 minutes ago  127.0.0.1:55210->6443/tcp                    demo-control-plane
dd461d2b9d4a  docker.io/kindest/node@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98              4 minutes ago  Up 4 minutes ago  0.0.0.0:3080->80/tcp, 0.0.0.0:3443->443/tcp  demo-worker
```

We can validate the state of the cluster too:

```bash
k config current-context

kind-demo

kubectl cluster-info

Kubernetes control plane is running at https://127.0.0.1:56141
CoreDNS is running at https://127.0.0.1:56141/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy


kubectl get pods -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-lqcs6                     1/1     Running   0          4m6s
kube-system          coredns-6d4b75cb6d-xgbxk                     1/1     Running   0          4m6s
kube-system          etcd-demo-control-plane                      1/1     Running   0          4m18s
kube-system          kindnet-tjfzj                                1/1     Running   0          4m6s
kube-system          kindnet-vc66d                                1/1     Running   0          4m1s
kube-system          kube-apiserver-demo-control-plane            1/1     Running   0          4m18s
kube-system          kube-controller-manager-demo-control-plane   1/1     Running   0          4m18s
kube-system          kube-proxy-5kp6d                             1/1     Running   0          4m6s
kube-system          kube-proxy-dfczd                             1/1     Running   0          4m1s
kube-system          kube-scheduler-demo-control-plane            1/1     Running   0          4m18s
local-path-storage   local-path-provisioner-6b84c5c67f-csxg6      1/1     Running   0          4m6s
```

We can check the current Kubernetes `context` using `kubectl`:

```bash
k config  get-contexts
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
*         kind-demo   kind-demo   kind-demo
```