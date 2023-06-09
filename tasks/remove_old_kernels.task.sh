#!/bin/bash

description="Remove old kernel packages that are no longer in use."

# Function to remove old kernel packages
run() {
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
