#!/bin/bash

# Function to remove unused packages and their associated configuration files
remove_unused_packages() {
    sudo apt autoremove --purge -y
}

# Function to display help message
display_help() {
    echo "Task: Remove Unused Packages and Configuration Files"
    echo "--------------------------------------------------"
    echo "This task removes unused packages and their associated configuration files."
    echo
    echo "Usage: remove_unused_packages.task.sh"
    echo
    echo "Options:"
    echo "  --help  Display this help message."
    echo
}

# Check if the help option is provided
if [[ "$1" == "--help" ]]; then
    display_help
else
    remove_unused_packages
fi
