#!/bin/sh
#
# This is the cleanup script for Apple Mac OS

# Kind
kind delete cluster demo
brew uninstall kind

# remove Minikube
minikube stop
minikube delete
rm -f /usr/local/bin/minikube

# remove brew installed files
brew uninstall kubectl

# stop Colima and remove it
colima kubernetes delete
colima stop

brew uninstall colima
brew uninstall docker

# Remove Podman
podman machine stop
podman machine rm
brew uninstall podman
brew uninstall podman-desktop



# Remove tooling
brew uninstall kubecolor/tap/kubecolor

# Remove ZSH setup
rm -f ~/.p10k.zsh
sed -i ' ' -e 's/^ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/g'  ~/.zshrc