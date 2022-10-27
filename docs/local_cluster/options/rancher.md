# Rancher Desktop as Docker Desktop replacement 

!!! important
    This step is not executed as part of the tutorial it's only a reciepes how to replace Docker for Desktop


Rancher Desktop an open-source desktop application for Mac, Windows and Linux. Rancher Desktop runs Kubernetes and container management on your desktop. You can choose the version of Kubernetes you want to run. You can build, push, pull, and run container images using either containerd or Moby (dockerd). The container images you build can be run by Kubernetes immediately without the need for a registry.


## Install Rancher Desktop

Follow the [instructions](https://rancherdesktop.io/) to setup Rancher Desktop for preferred OS.


## Configure nerdctl

`nerdctl` is a Docker-compatible CLI for containerd:

- Supports rootless mode
- Supports lazy-pulling
- Supports Docker Compose (nerdctl compose up)


`nerdctl` get installed as part of Rancher Desktop and can be configured to replace docker command:


```
nerdctl help

alias docker=nerdctl
```

That should be added to `~/.bashrc` or `~/.zshrc`

```
docker help
```


## Run Containers with nerdctl

```
docker container ls

docker container run --rm -it \
    alpine echo "Is it working?"
```

## Docker Compose with nerdctl #


```
docker compose up --detach

docker container ls

docker compose down
```

## Container Images with nerdctl

```
docker image build \
    --tag $DH_USER/devops-toolkit \
    .

docker login \
    --username $DH_USER \
    --password $DH_PASS

docker image push $DH_USER/devops-toolkit

docker image tag \
    $DH_USER/devops-toolkit \
    $DH_USER/devops-toolkit:0.0.1

docker image ls
```

