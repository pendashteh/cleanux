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

# Step 1: Remove Unnecessary Packages
execute_cleanup_step "Remove Unnecessary Packages" "remove_unnecessary_packages.sh"

# Step 2: Clear Package Cache
execute_cleanup_step "Clear Package Cache" "clear_package_cache.sh"

# Step 3: Remove Old Kernels
execute_cleanup_step "Remove Old Kernels" "remove_old_kernels.sh"

# Step 4: Clean Up APT Cache
execute_cleanup_step "Clean Up APT Cache" "clean_up_apt_cache.sh"

# Step 5: Remove Orphaned Packages
execute_cleanup_step "Remove Orphaned Packages" "remove_orphaned_packages.sh"

# Step 6: Clean Up Old Configuration Files
execute_cleanup_step "Clean Up Old Configuration Files" "clean_up_old_config_files.sh"

# Step 7: Remove Unused Packages and Configuration Files
execute_cleanup_step "Remove Unused Packages and Configuration Files" "remove_unused_packages.sh"

echo "Cleanup process completed."
