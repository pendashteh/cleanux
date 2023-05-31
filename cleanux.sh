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
  local saved_formatted=$(numfmt --to=iec-i --suffix=B "$saved")
  echo "$(tput setaf 2)Saved space: $saved_formatted$(tput sgr0)"
  echo
}

# Function to remove unnecessary packages
remove_unnecessary_packages() {
  local command="sudo apt autoremove"
  if confirm "$command"; then
    calculate_disk_space "/" "$command"
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
    calculate_disk_space "/" "$command"
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

  if command -v deborphan &> /dev/null; then
    local command="deborphan | xargs sudo apt-get -y remove --purge"
    if confirm "$command"; then
      calculate_disk_space "/" "$command"
    fi
  fi
}

# Function to clean up old configuration files
clean_up_old_config_files() {
  local command="sudo dpkg --purge \$(dpkg -l | awk '/^rc/ { print \$2 }')"
  if confirm "$command"; then
    calculate_disk_space "/" "$command"
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
