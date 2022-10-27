# Colima as Docker Desktop replacement for MAC OS

!!! important
    This step is not executed as part of the tutorial it's only a reciepes how to replace Docker for Desktop


Colima is a full Docker-Desktop replacement. It is specific to Mac OSX. Just use plain Docker or Containerd on Linux.

With Colima you get:

- Intel and M1 Macs support
- Simple CLI interface
- Both Docker and Containerd support
- Port Forwarding
- Volume mounts
- Bundeled Kubernetes cluster
- A full replacement of Docker-for-Desktop

## Install

```bash
brew install colima
brew install docker # if you're using the Docker shim
```

!!! note

    Install `Colima` version `v0.4.6` or newer, which solves a bug with Kubernetes version reset (see https://github.com/abiosoft/colima/issues/417)

## Usage

!!! note "Colima Config file"
    `Colima` uses a config file, located by default in `$HOME/.colima/default/colima.yaml`.

    We're not going to dive into it, but you can update this file to change some of the parameters
    instead of specifying it on the command-line. 
    
    This file is auto-created when you first start Colima.

```bash
colima start --runtime containerd --with-kubernetes --kubernetes-version v1.24.4+k3s1
colima status

# other start options not used for this tutorial
colima start                                         # default using Docker runtime
colima start --with-kubernetes                       # start kubernetes local cluster
colima start --runtime containerd --with-kubernetes  # remove docker completely
```

Once Colima is running we can start using it. 

!!! note "Container Interface"
    Because we used `containerd`, we have to use the `nerdctl` command instead of `docker`. 
    
    `nerdctl` is installed by Colima itself.

Run a container for 20 seconds:

```bash
nerdctl run -d alpine:latest sleep 20

colima nerdctl ps # list running containers, execute multiple times to see the container stop after 10s
```

We started Colima with a `kubernetes` cluster. By default Colima will update your `kubeconfig` 
to add this cluster and set this new context as default.

```bash
kubectl config get-contexts

kubectl get pods -A

kubectl version
```

## Stop

For the rest of the presentation we're not going to use Colima. You can stop it:

```bash
colima kubernetes delete # stop k8s and delete the associated files
colima stop
```