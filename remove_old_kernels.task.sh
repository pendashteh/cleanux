#!/bin/bash

# Function to remove old kernel packages
remove_old_kernels() {
    sudo apt autoremove --purge -y
    sudo apt install byobu # Ensure a package is installed after removing the kernel
}

# Function to display help message
display_help() {
    echo "Task: Remove Old Kernels"
    echo "------------------------"
    echo "This task removes old kernel packages that are no longer in use."
    echo
    echo "Usage: remove_old_kernels.task.sh"
    echo
    echo "Options:"
    echo "  --help  Display this help message."
    echo
}

# Check if the help option is provided
if [[ "$1" == "--help" ]]; then
    display_help
else
    remove_old_kernels
fi
