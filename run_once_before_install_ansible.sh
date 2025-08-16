#!/bin/bash
# This script installs Ansible on a debian system if it is not already installed.

if ! command -v ansible &> /dev/null; then
    echo "Ansible is not installed. Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible
else
    echo "Ansible is already installed."
fi

ansible-playbook ./.bootstrap/setup.yml --ask-become-pass

if [ $? -eq 0 ]; then
    echo "Ansible playbook executed successfully."
else
    echo "Ansible playbook execution failed."
fi
