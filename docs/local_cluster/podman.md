# Podman

!!! important
    If you already have Docker-Desktop or Docker Engine (Linux) installed and running, skip this step for the demo and go directly to [Deploying applications with kubectl](../app_deployment.md)


`podman` is a full replacement of Docker and Docker-For-Desktop. It's the container Swiss-Army knife from RedHat.

What you get with Podman:

- Multiple image format support, including the OCI and Docker image formats
- Full management of container lifecycle, Docker CLI replacement
- Container image management (managing image layers, overlay filesystems, etc)
- Podman version 3.4+ now support M1 Apple Macs
- Replaces Docker-for-Desktop and includes a UI
- no bundled Kubernetes, use kind, minikube, k3s, microk8s...

It can also run and build rootless containers.
## Install

=== "Apple Mac OsX"

    ```bash title="OsX Install"
    brew install podman
    ```

=== "Linux Alpine"

    ```bash title="Linux Install"
    # Alpine
    sudo apk add podman
    ```

=== "Linux Centos"

    ```bash title="Linux Install"
    # Centos
    sudo yum -y install podman
    ```

=== "Ubuntu / Debian"

    ```bash title="Linux Install"
    # ubuntu / Debian
    apt-get -y install podman
    ```

=== "Windows"

    !!! note "Windows specific"
        On Windows, each Podman machine is backed by a virtualized Windows System for Linux (WSLv2) distribution. The podman command can be run directly from your Windows PowerShell (or CMD) prompt, where it remotely communicates with the podman service running in the WSL environment.

        Please [check the docs](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md) for specific detailed instructions


Optionally, Download Podman Desktop (UI) from the [official website](https://iongion.github.io/podman-desktop-companion/)

## Setup
    
By default `Podman` set up a VM Machine of 1 CPU, 2Gb of memory, 100Gb of disk.

In order to support demo needs create Podman VM with following parameters:

```bash
podman machine init \
--cpus=2 \
--memory=4096 \
--disk-size=200 \
--now

# podman machine start # Not required because of --now option
```

Check Podman is running:

```bash
podman info
```

Make Docker command call Podman, Podman is command-line compatible with Docker:

```bash
mv -f /usr/local/bin/docker /usr/local/bin/docker-orig
ln -s /usr/local/bin/podman /usr/local/bin/docker
```

Point the default Docker socket to the Podman socket. This is needed as some apps use a hardcoded path to Docker:

```bash
# This is needed so every app "hardcoded" for Docker will work
export DOCKER_HOST="unix://$HOME/.local/share/containers/podman/machine/podman-machine-default/podman.sock"
```

## Usage

You can use podman to search for well-known images: 

```bash
podman search httpd
```

You can run an image with the same command as with `docker`:

```bash
podman run -d alpine:latest sleep 20
```

Then, list the running containers multiple times:

```bash
podman ps -a
```
```bash title="output"
CONTAINER ID  IMAGE                             COMMAND     CREATED      STATUS                 PORTS     NAMES
c4b74e45f004  docker.io/library/alpine:latest   sleep 20    2 hours ago  Up 2 hours ago                   loving_wu
```

You can also use the `docker` command, as it's executing `podman` in the background, and `podman` support all the same arguments:

```bash
docker ps -a
```
```bash title="output"
CONTAINER ID  IMAGE                             COMMAND     CREATED      STATUS                 PORTS     NAMES
c4b74e45f004  docker.io/library/alpine:latest   sleep 20    2 hours ago  Exited (0) 2 hours ago
```

## Tips and Tricks

You can also use Podman to convert a running docker image into a Kubernetes yaml using:

```bash
podman generate kube my-running-app -f ~/my-running-app.yaml
```

You can also convert a yaml file back to bunch of containers run in Podman:

```bash
podman play kube /mnt/mysharedfolder/my-running-app.yaml
```

!!! warning

    Sometimes some pods way complaine with `failed to create fsnotify watcher: too many open files`.

    This is due to the tuning of the `machine` default values that are too low. Edit the machine:

    ```bash 
    podman machine ssh
    sudo -s
    ```

    then add those 2 lines in `/etc/sysctl.conf`:

    ```
    fs.inotify.max_user_instances = 10240
    fs.inotify.max_user_watches = 122880
    ```

    And execute:

    ```bash
    sysctl -w fs.inotify.max_user_instances=10240
    sysctl -w fs.inotify.max_user_watches=122880
    ```

## Next

Podman is a cool alternative to Docker Engine and Docker CLI. 

However, Podman does not provide a K8s cluster.

Create a local `Kind` Kubernetes cluster in [next chapter](kind.md) !