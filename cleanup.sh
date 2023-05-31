#!/bin/bash

# https://chat.openai.com/share/1b4bcd84-0a6a-4e70-aff9-e1fa363c2e46

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
  before=$(df -h --output=avail "$1" | sed -n 2p | awk '{print $1}')
  echo
  echo "$(tput setaf 3)Executing command: $2$(tput sgr0)"
  echo
  eval "$2"
  after=$(df -h --output=avail "$1" | sed -n 2p | awk '{print $1}')
  saved=$(echo "$before - $after" | bc)
  saved_formatted=$(numfmt --to=iec-i --suffix=B "$saved")
  echo "$(tput setaf 2)Saved space: $saved_formatted$(tput sgr0)"
  echo
}

auto_accept=""
if [[ $1 == "-a" ]]; then
  auto_accept="a"
fi

# Remove unnecessary packages
command="sudo apt autoremove"
if confirm "$command"; then
  calculate_disk_space "/" "$command"
fi

# Clear package cache
command="sudo apt clean"
if confirm "$command"; then
  calculate_disk_space "/" "$command"
fi

# Remove old kernels
command="sudo apt autoremove --purge"
if confirm "$command"; then
  if dpkg -l | awk '/^rc/ { print $2 }' | grep -q "."; then
    calculate_disk_space "/" "$command"
  else
    echo "$(tput setaf 1)No packages to purge.$(tput sgr0)"
    echo
  fi
fi

# Clean up APT cache
command="sudo apt-get clean"
if confirm "$command"; then
  calculate_disk_space "/" "$command"
fi

# Remove orphaned packages
command="deborphan | xargs sudo apt-get -y remove --purge"
if confirm "$command"; then
  calculate_disk_space "/" "$command"
fi

# Clean up old configuration files
command="sudo dpkg --purge \$(dpkg -l | awk '/^rc/ { print \$2 }')"
if confirm "$command"; then
  if dpkg -l | awk '/^rc/ { print $2 }' | grep -q "."; then
    calculate_disk_space "/" "$command"
  else
    echo "$(tput setaf 1)No packages to purge.$(tput sgr0)"
    echo
  fi
fi

# Remove unused packages and their associated configuration files
command="sudo apt-get autoremove --purge"
if confirm "$command"; then
  calculate_disk_space "/" "$command"
fi

echo "$(tput setaf 6)Cleanup complete!$(tput sgr0)"
