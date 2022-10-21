# Podman

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
    brew install podman-desktop
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

=== "Podman Desktop (UI)"

    Download the UI from the [official website](https://iongion.github.io/podman-desktop-companion/).


## Setup

!!! note "Docker replacement"
    Usually you will symlink `podman` to `docker` because using an alias is not working when some apps or scripts try to call the hard-coded `docker` commandline.

```bash
podman machine init
podman machine start
podman info

# Make Docker command call Podman, Podman is command-line compatible with Docker
mv -f /usr/local/bin/docker /usr/local/bin/docker-orig
ln -s /usr/local/bin/podman /usr/local/bin/docker

# Tell Docker to connect to Podman
# This is needed so every app "hardcoded" for Docker will work
export DOCKER_HOST="unix://$HOME/.local/share/containers/podman/machine/podman-machine-default/podman.sock"
```

## Usage

Podman is a cool alternative to Docker. It is highly maintained and updated and also offer building Containers without any daemon
Podman does not provide a K8s cluster, you have to use another solution (Kind !)

You can use podman to search for well-known images: 

```bash
podman search httpd
```

You can run an image with the same command as with `docker`:

```bash
podman run -d alpine:latest sleep 10
```

You can also use Podman to convert a running docker image into a Kubernetes yaml using:

```bash
podman generate kube my-running-app -f ~/my-running-app.yaml
```

You can also convert a yaml file back to bunch of containers run in Podman:

```bash
podman play kube /mnt/mysharedfolder/my-running-app.yaml
```

## Next

Create a local Kubernetes cluster in [next chapter](kind.md) !