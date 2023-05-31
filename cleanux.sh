#!/bin/bash

# Cleanux - System Cleanup Utility

# Function to execute a cleanup step
execute_cleanup_step() {
    local step_name=$1
    local step_script=$2
    
    echo -e "\n\e[1mRunning cleanup step: $step_name\e[0m"
    echo "-----------------------------------------------"
    bash "$step_script"
    echo "-----------------------------------------------"
}

# Function to display brief help for a task
display_task_brief_help() {
    local task_script=$1
    
    local task_name=$(basename "$task_script" .task.sh)
    local task_desc=$(grep -oP '(?<=^# Purpose: ).*' "$task_script" | sed -e 's/^/  /')
    
    echo -e "\e[1m$task_name\e[0m"
    echo "$task_desc"
    echo
}

# Function to display detailed help for a task
display_task_detailed_help() {
    local task_script=$1
    
    bash "$task_script" --help
}

# Display brief help for all tasks
echo -e "\e[1mCleanux - System Cleanup Utility\e[0m"
echo "--------------------------------------"
echo -e "\e[1mOverview of Tasks:\e[0m"
echo

for task_script in *.task.sh; do
    if [[ -f "$task_script" ]]; then
        display_task_brief_help "$task_script"
    fi
done

# Function to display more help for a task
display_task_more_help() {
    local task_script=$1
    
    echo -e "\n\e[1mMore Help:\e[0m"
    display_task_detailed_help "$task_script"
}

# Prompt to run individual tasks or all tasks
echo -e "\e[1mUsage Instructions:\e[0m"
echo "To run individual tasks, use the following format:"
echo "  ./cleanux.sh [task_name]"
echo
echo "To run all tasks, use the following command:"
echo "  ./cleanux.sh --all"

# Execute selected tasks or run all tasks
if [[ "$1" == "--all" ]]; then
    for task_script in *.task.sh; do
        if [[ -f "$task_script" ]]; then
            execute_cleanup_step "$(basename "$task_script" .task.sh)" "$task_script"
        fi
    done
elif [[ -n "$1" ]]; then
    task_script="$1.task.sh"
    if [[ -f "$task_script" ]]; then
        execute_cleanup_step "$1" "$task_script"
    else
        echo -e "\n\e[1mTask not found: $1\e[0m"
        display_task_more_help "$task_script"
    fi
fi

echo -e "\n\e[1mCleanup process completed.\e[0m"
