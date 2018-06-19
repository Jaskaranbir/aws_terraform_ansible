#!/bin/bash

# NOTE: This script is read as file-contents, so using
# relative paths in the script might cause errors!

# This script is only for basic bootstrapping.
# Please use Ansible for further provisioning.
# (Use Ansible for Configuration Management!)

# From https://github.com/hashicorp/terraform/issues/2811
# Wait until machine-bootup
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
  echo -e "\033[1;36mWaiting for cloud-init..."
  sleep 2
done

# Install Python
sudo apt-add-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python3.7
