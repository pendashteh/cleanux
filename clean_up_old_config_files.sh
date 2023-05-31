#!/bin/bash

# Clean up old configuration files
sudo dpkg --purge $(dpkg -l | grep '^rc' | awk '{print $2}')
