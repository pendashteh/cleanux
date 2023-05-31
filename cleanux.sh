#!/bin/bash

# Cleanux - System Cleanup Utility

# Define task script suffix
task_suffix='.task.sh'

# Function to execute a cleanup step
execute_cleanup_step() {
    local step_name=$1
    local step_script=$2

    echo -e "\n\e[1mRunning cleanup step: $step_name\e[0m"
    echo "-----------------------------------------------"
    source "$step_script"
    run
    echo "-----------------------------------------------"
}

# Function to display brief help for a task
display_task_brief_help() {
    local task_num=$1
    local task_script=$2

    local task_name=$(basename "$task_script" "$task_suffix")
    local task_description=""
    source "$task_script"
    task_description="${description}"

    echo -e "$task_num. \e[1mTask: $task_name\e[0m"
    echo "- $task_description"
}

# Function to display detailed help for a task
display_task_detailed_help() {
    local task_script=$1

    source "$task_script"
    display_help
}

# Array to store task file names
task_files=()

# Display brief help for all tasks
echo -e "\e[1mCleanux - System Cleanup Utility\e[0m"
echo "--------------------------------------"
echo -e "\e[1mAvailable Tasks:\e[0m"
echo

i=1
for task_script in *"$task_suffix"; do
    if [[ -f "$task_script" ]]; then
        display_task_brief_help "$i" "$task_script"
        echo
        task_files+=("$task_script")
        ((i++))
    fi
done

# Display the option to run all tasks
echo -e "$i. \e[1mTask: All\e[0m"
echo "- Run all tasks"

# Prompt to select the task to execute
read -p "Enter the number of the task to execute (or 'q' to quit): " task_num
if [[ "$task_num" == "q" ]]; then
    echo -e "\n\e[1mCleanup process aborted.\e[0m"
    exit 0
fi

# Validate the task number
if ! [[ "$task_num" =~ ^[0-9]+$ ]] || (( task_num < 1 || task_num > i )); then
    echo -e "\n\e[1mInvalid task number. Cleanup process aborted.\e[0m"
    exit 1
fi

# Execute the selected task(s) or all tasks
if (( task_num == i )); then
    for task_script in "${task_files[@]}"; do
        task_name=$(basename "$task_script" "$task_suffix")
        execute_cleanup_step "$task_name" "$task_script"
    done
else
    task_script="${task_files[$((task_num-1))]}"
    task_name=$(basename "$task_script" "$task_suffix")
    execute_cleanup_step "$task_name" "$task_script"
fi

echo -e "\n\e[1mCleanup process completed.\e[0m"
