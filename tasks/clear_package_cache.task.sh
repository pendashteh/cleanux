#!/bin/bash


# Description variable for the task
description="Sample Task - Description of what this task does"

# Function to clear package cache
run() {
    echo CLEARING NOW!
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
