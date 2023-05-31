# Ubuntu System Cleanup Script

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> A bash script to clean up an Ubuntu system by removing unnecessary packages and freeing up disk space.

The Ubuntu System Cleanup Script is a simple bash script that automates the process of cleaning up an Ubuntu system by removing unnecessary packages, clearing package cache, removing old kernels, cleaning up APT cache, removing orphaned packages, cleaning up old configuration files, and removing unused packages and their associated configuration files.

## Features

- Interactive prompts with confirmation for each cleanup step
- Automatic cleanup option with the `-a` flag
- Human-readable output showing the amount of saved disk space
- Error handling for cases when there are no packages to purge

## Usage

To use the script, follow these steps:

1. Ensure that you have the necessary permissions to execute the script.

2. Run the script in one of the following modes:

   - Interactive mode: `./cleanup_script.sh`
   - Automatic mode (accepts all prompts without confirmation): `./cleanup_script.sh -a`

3. Follow the prompts to confirm or skip each cleanup step.

## Credits

This script is built upon the original work by OpenAI and has been modified for specific needs. OpenAI's contributions are much appreciated.

## License

The Ubuntu System Cleanup Script is licensed under the [MIT License](LICENSE).
