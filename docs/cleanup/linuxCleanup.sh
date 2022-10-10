#!/bin/sh
#
# This is the cleanup script for Linux

# remove kubectl
rm -f /usr/local/bin/kubectl

# stop Colima and remove it
colima kubernetes delete
colima stop

# stop and delete Podman
# TODO

