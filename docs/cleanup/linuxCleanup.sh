#!/bin/sh
#
# This is the cleanup script for Linux


# Kind
kind delete cluster demo
rm -f /usr/local/bin/kind

# remove Minikube
minikube stop
minikube delete
rm -f /usr/local/bin/minikube

# remove kubectl
rm -f /usr/local/bin/kubectl

# stop Colima and remove it
colima kubernetes delete
colima stop

# stop and delete Podman
# TODO

# Remove K3s
# TODO: delete the cluster and remove VMs files
/usr/local/bin/k3s-uninstall.sh

# Remove ZSH setup
rm -f ~/.p10k.zsh
sed 's/^ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/g' -i ~/.zshrc