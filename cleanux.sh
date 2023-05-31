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

# Function to display help for a task
display_task_help() {
    local task_script=$1
    
    bash "$task_script" --help
}

# Display overview of tasks and usage instructions
echo -e "\e[1mCleanux - System Cleanup Utility\e[0m"
echo "--------------------------------------"
echo -e "\e[1mOverview of Tasks:\e[0m"
echo

for task_script in *.task.sh; do
    if [[ -f "$task_script" ]]; then
        echo -e "\e[1m$(basename "$task_script" .task.sh)\e[0m"
        bash "$task_script" --help | sed 's/^/  /'
        echo
    fi
done

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
else
    for task_script in "$@"; do
        if [[ -f "$task_script.task.sh" ]]; then
            execute_cleanup_step "$task_script" "$task_script.task.sh"
        elif [[ "$task_script" != "--all" ]]; then
            echo -e "\n\e[1mTask not found: $task_script\e[0m"
        fi
    done
fi

echo -e "\n\e[1mCleanup process completed.\e[0m"
