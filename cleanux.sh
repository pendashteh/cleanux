#!/bin/bash

# Function to display confirmation prompt
confirm() {
  if [[ $auto_accept == "a" ]]; then
    return 0
  fi

  echo "$(tput setaf 3)Executing command: $1$(tput sgr0)"
  read -p "$(tput setaf 6)Are you sure you want to proceed? (y/n/a): $(tput sgr0)" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  elif [[ $REPLY =~ ^[Aa]$ ]]; then
    auto_accept="a"
    return 0
  fi
  return 1
}

# Function to calculate disk space before and after a command
calculate_disk_space() {
  local before=$(df -h --output=avail "$1" | sed -n 2p | awk '{print $1}')
  eval "$2"
  local after=$(df -h --output=avail "$1" | sed -n 2p | awk '{print $1}')
  local saved=$(echo "$before - $after" | bc)
  local saved_formatted=$(format_size "$saved")
  echo "$(tput setaf 2)Saved space: $saved_formatted$(tput sgr0)"
  echo
}

# Function to format the size with appropriate units
format_size() {
  local size=$1
  local unit=""
  if (( size < 1024 )); then
    echo "$size B"
  elif (( size < 1048576 )); then
    size=$(printf "%.2f" "$(bc -l <<< "$size / 1024")")
    echo "$size KB"
  elif (( size < 1073741824 )); then
    size=$(printf "%.2f" "$(bc -l <<< "$size / 1048576")")
    echo "$size MB"
  else
    size=$(printf "%.2f" "$(bc -l <<< "$size / 1073741824")")
    echo "$size GB"
  fi
}

# Check if deborphan is installed
if ! command -v deborphan &> /dev/null; then
  echo "$(tput setaf 1)Deborphan is not installed.$(tput sgr0)"
  echo "$(tput setaf 3)You can install deborphan by running the following command:$(tput sgr0)"
  echo "$(tput setaf 6)sudo apt-get install deborphan$(tput sgr0)"
  echo
  if [[ $auto_accept != "a" ]]; then
    read -p "$(tput setaf 6)Do you want to install deborphan? (y/n/a): $(tput sgr0)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      sudo apt-get install deborphan
    elif [[ $REPLY =~ ^[Aa]$ ]]; then
      auto_accept="a"
    fi
  fi
fi

# Function to remove unnecessary packages
remove_unnecessary_packages() {
  local command="sudo apt autoremove"
  if confirm "$command"; then
    if dpkg -l | awk '/^rc/ { print $2 }' | grep -q "."; then
      calculate_disk_space "/" "$command"
    else
      echo "$(tput setaf 1)No packages to purge.$(tput sgr0)"
      echo
    fi
  fi
}

# Function to clear package cache
clear_package_cache() {
  local command="sudo apt clean"
  if confirm "$command"; then
    calculate_disk_space "/" "$command"
  fi
}

# Function to remove old kernels
remove_old_kernels() {
  local command="sudo apt autoremove --purge"
  if confirm "$command"; then
    if dpkg -l | awk '/^rc/ { print $2 }' | grep -q "."; then
      calculate_disk_space "/" "$command"
    else
      echo "$(tput setaf 1)No packages to purge.$(tput sgr0)"
      echo
    fi
  fi
}

# Function to clean up APT cache
clean_up_apt_cache() {
  local command="sudo apt-get clean"
  if confirm "$command"; then
    calculate_disk_space "/" "$command"
  fi
}

# Function to remove orphaned packages
remove_orphaned_packages() {
  if command -v deborphan &> /dev/null; then
    local command="deborphan | xargs sudo apt-get -y remove --purge"
    if confirm "$command"; then
      if dpkg -l | awk '/^rc/ { print $2 }' | grep -q "."; then
        calculate_disk_space "/" "$command"
      else
        echo "$(tput setaf 1)No packages to purge.$(tput sgr0)"
        echo
      fi
    fi
  fi
}

# Function to clean up old configuration files
clean_up_old_config_files() {
  local command="sudo dpkg --purge \$(dpkg -l | awk '/^rc/ { print \$2 }')"
  if confirm "$command"; then
    if dpkg -l | awk '/^rc/ { print $2 }' | grep -q "."; then
      calculate_disk_space "/" "$command"
    else
      echo "$(tput setaf 1)No packages to purge.$(tput sgr0)"
      echo
    fi
  fi
}

# Function to remove unused packages and their associated configuration files
remove_unused_packages() {
  local command="sudo apt-get autoremove --purge"
  if confirm "$command"; then
    calculate_disk_space "/" "$command"
  fi
}

auto_accept=""
if [[ $1 == "-a" ]]; then
  auto_accept="a"
fi

remove_unnecessary_packages
clear_package_cache
remove_old_kernels
clean_up_apt_cache
remove_orphaned_packages
clean_up_old_config_files
remove_unused_packages

echo "$(tput setaf 6)Cleanup complete!$(tput sgr0)"
