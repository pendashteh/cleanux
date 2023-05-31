#!/bin/bash

# Function to clear package cache
clear_package_cache() {
    sudo apt clean
}

# Function to display help message
display_help() {
    echo "Task: Clear Package Cache"
    echo "-------------------------"
    echo "This task clears the cache of downloaded packages stored in the APT package cache."
    echo
    echo "Usage: clear_package_cache.task.sh"
    echo
    echo "Options:"
    echo "  --help  Display this help message."
    echo
}

# Check if the help option is provided
if [[ "$1" == "--help" ]]; then
    display_help
else
    clear_package_cache
fi
