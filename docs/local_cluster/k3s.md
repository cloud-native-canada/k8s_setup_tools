# K3s 

K3s is a local (and remote) K8s cluster from Rancher Labs.

Lightweight. Easy to install, half the memory, all in a binary of less than 100 MB.

- Both ARM64 and ARMv7 are supported
- Can create a real cluster with different physical nodes

[https://k3s.io/](https://k3s.io/)

# Install

!!! warning
    This is only for Linux. On OSX, use Colima or Kind.
    
```bash
# All-in one ; install and start
curl -sfL https://get.k3s.io | sh - 

sudo k3s server &
# Kubeconfig is written to /etc/rancher/k3s/k3s.yaml
sudo k3s kubectl get node


```