#!/bin/bash

description="Identify and remove orphaned packages that are no longer required by any installed software."

# Function to remove orphaned packages
run() {
    sudo deborphan | xargs sudo apt-get -y remove --purge
}

# Function to display help message
display_help() {
    echo "Task: Remove Orphaned Packages"
    echo "------------------------------"
    echo "This task identifies and removes orphaned packages that are no longer required by any installed software."
    echo
    echo "Usage: remove_orphaned_packages.task.sh"
    echo
    echo "Options:"
    echo "  --help  Display this help message."
    echo
}
