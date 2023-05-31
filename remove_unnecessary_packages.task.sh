#!/bin/bash

description="Remove unnecessary packages that are no longer required by any installed software."

# Function to remove unnecessary packages
run() {
    sudo apt autoremove --purge -y
}

# Function to display help message
display_help() {
    echo "Task: Remove Unnecessary Packages"
    echo "--------------------------------"
    echo "This task removes unnecessary packages that are no longer required by any installed software."
    echo
    echo "Usage: remove_unnecessary_packages.task.sh"
    echo
    echo "Options:"
    echo "  --help  Display this help message."
    echo
}
