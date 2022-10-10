# Podman

`podman` is a full replacement of Docker and Docker Desktop.

It can also run and build rootless containers.
## Install

```bash
brew install podman
brew install podman-desktop
```

## Setup

!!! note "Docker replacement"
    Usually you will symlink `podman` to `docker` because using an alias is not working when some apps or scripts try to call the hard-coded `docker` commandline.

```bash
podman machine init
podman machine start
podman info

# Make docker command call podman
ln -s /usr/local/bin/podman /usr/local/bin/docker

# Tell Docker to connect to Podman
export DOCKER_HOST="unix://$HOME/.local/share/containers/podman/machine/podman-machine-default/podman.sock"
```