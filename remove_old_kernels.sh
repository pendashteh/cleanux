#!/bin/bash

# Remove old kernel packages
sudo apt autoremove --purge -y
sudo apt install byobu # Ensure a package is installed after removing kernel
