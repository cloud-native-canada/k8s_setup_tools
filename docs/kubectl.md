# Kubectl install

## using Brew

this is the simplest for OsX:

```bash
brew install kubectl
```

## Installing from the source project

This is the prefered installation for Linux or when you want full control.

If you want to install a specific version, check the [the list of official releases](https://dl.k8s.io/release/stable.txt.).

=== "Apple Mac OsX"

    ```bash title="OsX Install"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
    chmod 755 kubectl
    mv kubectl /usr/local/bin

    # install a specific version
    curl -LO "https://dl.k8s.io/release/v1.25.0/bin/darwin/amd64/kubectl"
    chmod 755 kubectl
    mv kubectl /usr/local/bin

    # for Apple M1/M2 processors
    curl -LO "https://dl.k8s.io/release/v1.25.0/bin/darwin/arm64/kubectl"
    chmod 755 kubectl
    mv kubectl /usr/local/bin
    ```

=== "Linux"

    ```bash title="Linux Install"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod 755 kubectl
    mv kubectl /usr/local/bin

    # install a specific version
    curl -LO "https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl"
    chmod 755 kubectl
    mv kubectl /usr/local/bin
    ```

=== "Windows"

    ```bash title="Windows Install"
    curl -LO "https://dl.k8s.io/release/v1.25.0/bin/windows/amd64/kubectl.exe"
    ```

## Install from Gcloud
If you already have `gcloud` command installed, you can install `kubectl`:

```bash
gcloud components install kubectl
```

## Validate kubectl install

`cluster-info` command tells which cluster you're connecting to:

```bash
kubectl cluster-info
```

## Check Kubectl version

the `version` command tells which `client` and `server` versions you're using. 

```bash 
kubectl version
```
```bash
Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.2"}
Server Version: version.Info{Major:"1", Minor:"20+", GitVersion:"v1.20.9-gke.1001"}

WARNING: version difference between client (1.22) and server (1.20) exceeds the supported minor version skew of +/-1
```

!!! note
    as returned here, it's usually recommended to use a `kubectl` version + or - one version away from the `server` version.

## Ref

- [gcloud](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl?hl=fr#apt)
- [official install doc](https://kubernetes.io/docs/tasks/tools/#kubectl)