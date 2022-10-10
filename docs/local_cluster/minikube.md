# miniKube

Minikube is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

All you need is Docker (or similarly compatible) container or a Virtual Machine environment

- Well documented
- Can use many container Runtime (get rid of Docker !)

[https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/)

# Install

=== "Apple Mac OsX"

    ```bash title="OsX Install"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
    sudo install minikube-darwin-amd64 /usr/local/bin/minikube

    ```

=== "Linux"

    ```bash title="Linux Install"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube

    ```

=== "Windows"

    ```bash title="Windows Install"
    New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
    Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
    ```

!!! note "Install Matrix"
    Refer to the [Installation Matrix](https://minikube.sigs.k8s.io/docs/start/) to get the right command, like installing on Arm64 CPU.

## Usage

```bash
minikube start
```

Exemple OsX Cluster:

```bash
minikube start
😄  minikube v1.27.1 on Darwin 12.6
✨  Automatically selected the hyperkit driver. Other choices: virtualbox, ssh, podman (experimental), qemu2 (experimental)
💾  Downloading driver docker-machine-driver-hyperkit:
    > docker-machine-driver-hyper...:  65 B / 65 B [---------] 100.00% ? p/s 0s
    > docker-machine-driver-hyper...:  8.42 MiB / 8.42 MiB  100.00% 4.40 MiB p/
🔑  The 'hyperkit' driver requires elevated permissions. The following commands will be executed:

    $ sudo chown root:wheel /Users/prune/.minikube/bin/docker-machine-driver-hyperkit
    $ sudo chmod u+s /Users/prune/.minikube/bin/docker-machine-driver-hyperkit


💿  Downloading VM boot image ...
    > minikube-v1.27.0-amd64.iso....:  65 B / 65 B [---------] 100.00% ? p/s 0s
    > minikube-v1.27.0-amd64.iso:  273.79 MiB / 273.79 MiB  100.00% 3.59 MiB p/
👍  Starting control plane node minikube in cluster minikube
💾  Downloading Kubernetes v1.25.2 preload ...
    > preloaded-images-k8s-v18-v1...:  385.41 MiB / 385.41 MiB  100.00% 3.63 Mi
🔥  Creating hyperkit VM (CPUs=2, Memory=6000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.25.2 on Docker 20.10.18 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default


kubectl cluster-info

Kubernetes control plane is running at https://192.168.64.2:8443
CoreDNS is running at https://192.168.64.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

kubectl get po -A

NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-565d847f94-2mx8q           1/1     Running   0          109s
kube-system   etcd-minikube                      1/1     Running   0          2m2s
kube-system   kube-apiserver-minikube            1/1     Running   0          2m2s
kube-system   kube-controller-manager-minikube   1/1     Running   0          2m2s
kube-system   kube-proxy-rcklg                   1/1     Running   0          109s
kube-system   kube-scheduler-minikube            1/1     Running   0          2m2s
kube-system   storage-provisioner                1/1     Running   0          2m1s
```

We can check the current Kubernetes `context` using `kubectl`:

```bash
k config  get-contexts
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
          kind-demo   kind-demo   kind-demo
*         minikube    minikube    minikube    default
```