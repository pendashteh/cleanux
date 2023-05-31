#!/bin/bash

# Function to display confirmation prompt
confirm() {
  read -p "$1 (y/n): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

# Function to calculate disk space before and after a command
calculate_disk_space() {
  before=$(df -h --output=avail "$1" | sed -n 2p)
  $2
  after=$(df -h --output=avail "$1" | sed -n 2p)
  echo "Saved space: $((before-after))K"
  echo
}

# Remove unnecessary packages
if confirm "Remove unnecessary packages?"; then
  calculate_disk_space "/" "sudo apt autoremove"
fi

# Clear package cache
if confirm "Clear package cache?"; then
  calculate_disk_space "/" "sudo apt clean"
fi

# Remove old kernels
if confirm "Remove old kernels?"; then
  calculate_disk_space "/" "sudo apt autoremove --purge"
fi

# Clean up APT cache
if confirm "Clean up APT cache?"; then
  calculate_disk_space "/" "sudo apt-get clean"
fi

# Remove orphaned packages
if confirm "Remove orphaned packages?"; then
  calculate_disk_space "/" "deborphan | xargs sudo apt-get -y remove --purge"
fi

# Clean up old configuration files
if confirm "Clean up old configuration files?"; then
  calculate_disk_space "/" "sudo dpkg --purge \$(COLUMNS=200 dpkg -l | grep \"^rc\" | tr -s ' ' | cut -d ' ' -f 2)"
fi

# Remove unused packages and their associated configuration files
if confirm "Remove unused packages and associated configuration files?"; then
  calculate_disk_space "/" "sudo apt-get autoremove --purge"
fi

echo "Cleanup complete!"

