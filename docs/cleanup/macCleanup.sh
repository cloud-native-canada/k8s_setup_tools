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
brew uninstall podman
brew uninstall podman-desktop