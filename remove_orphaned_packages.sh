#!/bin/bash

# Remove orphaned packages
sudo deborphan | xargs sudo apt-get -y remove --purge
