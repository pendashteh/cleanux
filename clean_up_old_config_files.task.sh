#!/bin/bash

# Function to clean up old configuration files
clean_up_old_config_files() {
    local config_files="$(dpkg -l | grep '^rc' | awk '{print $2}')"

    if [[ -z "$config_files" ]]; then
        echo "No old configuration files to clean up."
        return
    fi

    sudo dpkg --purge $config_files
}

# Function to display help message
display_help() {
    echo "Task: Clean Up Old Configuration Files"
    echo "-------------------------------------"
    echo "This task removes old configuration files associated with packages that have been removed but not purged."
    echo
    echo "Usage: clean_up_old_config_files.task.sh"
    echo
    echo "Options:"
    echo "  --help  Display this help message."
    echo
}

# Check if the help option is provided
if [[ "$1" == "--help" ]]; then
    display_help
else
    clean_up_old_config_files
fi
