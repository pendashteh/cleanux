#!/bin/bash

# Cleanux - System Cleanup Utility

# Function to execute a cleanup step
execute_cleanup_step() {
    local step_name=$1
    local step_script=$2
    
    echo "Running cleanup step: $step_name"
    echo "---------------------------------"
    bash "$step_script"
    echo "---------------------------------"
    echo
}

# Function to display help for a task
display_task_help() {
    local task_script=$1
    
    bash "$task_script" --help
}

# Find all task files with pattern "*.task.sh" and execute them
for task_script in *.task.sh; do
    if [[ -f "$task_script" ]]; then
        echo "-------------------------------------------------------------------------"
        echo "$(basename "$task_script" .task.sh)"
        echo "-------------------------------------------------------------------------"
        bash "$task_script" --help
        echo
        execute_cleanup_step "$(basename "$task_script" .task.sh)" "$task_script"
    fi
done

echo "Cleanup process completed."
