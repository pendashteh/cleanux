#!/bin/bash

# Purpose: Clean up the APT cache by removing downloaded package files that are no longer needed.

# Function to clean up APT cache
clean_up_apt_cache() {
    sudo apt-get clean
}

# Function to display help message
display_help() {
    echo "Task: Clean Up APT Cache"
    echo "------------------------"
    echo "This task cleans up the APT cache by removing downloaded package files that are no longer needed."
    echo
    echo "Usage: clean_up_apt_cache.task.sh"
    echo
    echo "Options:"
    echo "  --help  Display this help message."
    echo
}

# Check if the help option is provided
if [[ "$1" == "--help" ]]; then
    display_help
else
    clean_up_apt_cache
fi
