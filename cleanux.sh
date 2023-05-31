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

# Function to display progress bar
display_progress() {
  local total_steps=$1
  local current_step=$2

  local max_length=40
  local filled_length=$((current_step * max_length / total_steps))
  local empty_length=$((max_length - filled_length))

  local progress_bar="["
  progress_bar+="$(tput setaf 2)"
  progress_bar+=$(printf '%*s' "$filled_length" | tr ' ' '=')
  progress_bar+=">"
  progress_bar+=$(printf '%*s' "$empty_length" | tr ' ' ' ')
  progress_bar+="$(tput sgr0)"
  progress_bar+="]"

  echo -ne "\r$progress_bar"
}

auto_accept=""
progress_mode="false"
if [[ $1 == "-a" ]]; then
  auto_accept="a"
elif [[ $1 == "--progress" ]]; then
  progress_mode="true"
fi

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

# Remove unnecessary packages
command="sudo apt autoremove"
if confirm "$command"; then
  if [[ $progress_mode == "true" ]]; then
    display_progress 7 1
  fi
  calculate_disk_space "/" "$command"
fi

# Clear package cache
command="sudo apt clean"
if confirm "$command"; then
  if [[ $progress_mode == "true" ]]; then
    display_progress 7 2
  fi
  calculate_disk_space "/" "$command"
fi

# Remove old kernels
command="sudo apt autoremove --purge"
if confirm "$command"; then
  if [[ $progress_mode == "true" ]]; then
    display_progress 7 3
  fi
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
  if [[ $progress_mode == "true" ]]; then
    display_progress 7 4
  fi
  calculate_disk_space "/" "$command"
fi

# Remove orphaned packages
command="deborphan | xargs sudo apt-get -y remove --purge"
if confirm "$command"; then
  if [[ $progress_mode == "true" ]]; then
    display_progress 7 5
  fi
  if dpkg -l | awk '/^rc/ { print $2 }' | grep -q "."; then
    calculate_disk_space "/" "$command"
  else
    echo "$(tput setaf 1)No packages to purge.$(tput sgr0)"
    echo
  fi
fi

# Clean up old configuration files
command="sudo dpkg --purge \$(dpkg -l | awk '/^rc/ { print \$2 }')"
if confirm "$command"; then
  if [[ $progress_mode == "true" ]]; then
    display_progress 7 6
  fi
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
  if [[ $progress_mode == "true" ]]; then
    display_progress 7 7
    echo
  fi
  calculate_disk_space "/" "$command"
fi

echo "$(tput setaf 6)Cleanup complete!$(tput sgr0)"
