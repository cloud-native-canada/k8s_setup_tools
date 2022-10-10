#!/bin/sh
#
# This is the cleanup script for Apple Mac OS

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

# Kind
# Removing Docker/Podman will destroy your cluster, nothing special to do here
brew uninstall kind

# Remove tooling
brew uninstall kubecolor/tap/kubecolor
