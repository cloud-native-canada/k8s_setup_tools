# MiniKube as Docker Desktop replacement

!!! important
    This step is not executed as part of the tutorial it's only a reciepes how to replace Docker for Desktop


[Minikube](https://minikube.sigs.k8s.io/docs) is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

All you need is Docker (or similarly compatible) container or a Virtual Machine environment

- Well documented
- Can use many container Runtime (get rid of Docker !)

[https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/)

## Install Docker CLI 

```
brew install docker
```

# Install Minikube


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


# Start Docker with HyperKit (https://minikube.sigs.k8s.io/docs/drivers/hyperkit/)

```
minikube start --driver hyperkit # will be auto-detected
```

# Point Docker CLI to Docker Engine inside Minikube VM

```
minikube docker-env
eval $(minikube docker-env)
```


Show Cluster info

```bash
kubectl cluster-info
```

```bash
Kubernetes control plane is running at https://192.168.64.2:8443
CoreDNS is running at https://192.168.64.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

- Running pods

```bash
kubectl get po -A
```
```bash
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-565d847f94-2mx8q           1/1     Running   0          109s
kube-system   etcd-minikube                      1/1     Running   0          2m2s
kube-system   kube-apiserver-minikube            1/1     Running   0          2m2s
kube-system   kube-controller-manager-minikube   1/1     Running   0          2m2s
kube-system   kube-proxy-rcklg                   1/1     Running   0          109s
kube-system   kube-scheduler-minikube            1/1     Running   0          2m2s
kube-system   storage-provisioner                1/1     Running   0          2m1s
```

- All k8s contexts

We can check the current Kubernetes `context` using `kubectl`:

```bash
k config  get-contexts
```
```bash
CURRENT   NAME        CLUSTER     AUTHINFO    NAMESPACE
          kind-demo   kind-demo   kind-demo
*         minikube    minikube    minikube    default
```
