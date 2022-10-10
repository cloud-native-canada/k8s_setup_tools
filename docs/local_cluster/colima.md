# Colima

Colima is a full Docker Desktop replacement. It is specific to Max OSX. Just use plain Docker or Containerd on Linux.
## Install

```bash
brew install colima
brew install docker # if you're using the Docker shim
```

## Usage

!!! note "Colima Config file"
    `Colima` uses a config file, located by default in `$HOME/.colima/default/colima.yaml`.

    We're not going to dive into it, but you can update this file to change some of the parameters
    instead of specifying it on the command-line.

```bash
colima start --runtime containerd --with-kubernetes --kubernetes-version v1.24.4+k3s1
colima status

# other start options not used for this tutorial
colima start                                         # default using Docker runtime
colima start --with-kubernetes                       # start kubernetes local cluster
colima start --runtime containerd --with-kubernetes  # remove docker completely
```

Once Colima is running we can start using it. 

!!! note "Colima Config file"
    Because we used `containerd`, we have to use the `nerdctl` command instead of `docker`. 
    
    `nerdctl` is installed by Colima itself.

Run a container for 10 seconds:

```bash
nerdctl run -d alpine:latest sleep 10

colima nerdctl ps # list running containers, execute multiple times to see the container stop after 10s
```

We stated Colima with a `kubernetes` cluster. By default Colima will update your `kubeconfig` 
to connect to this cluster.

```bash
kubectl ctx

kubectl get pods -A

Kubectl version
```

## Stop
For the rest of the presentation we're not going to use Colima. Stop it:

```bash
colima kubernetes delete # we are using Kind cluster instead
colima stop
```