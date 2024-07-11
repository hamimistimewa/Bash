#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# - Delete user existing
# - Delete spesific domain and root directory

# Function to print progress
print_progress() {
    local progress=$1
    echo "======== Progress: ${progress}% ========"
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Get the username
read -p "Enter the username you want to delete: " username

# Get the root directory
read -p "Enter the root directory (e.g., /var/www/html/domain.com/public): " root_dir

# Confirm deletion
read -p "Are you sure you want to delete user $username and directory $root_dir? (y/n): " confirm
if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo "Aborting deletion."
    exit 1
fi

# Delete the user
echo "Deleting user $username and their home directory..."
deluser --remove-home $username > /dev/null 2>&1
print_progress 50

# Delete any remaining user directories in /home and /var/www/html/domain.com/
echo "Deleting any remaining user directories..."
if [[ -d /home/$username ]]; then
    rm -rf /home/$username
fi
if [[ -d /var/www/html/domain.com/$username ]]; then
    rm -rf /var/www/html/domain.com/$username
fi

# Delete the specified root directory
if [[ -d $root_dir ]]; then
    echo "Deleting directory $root_dir..."
    rm -rf $root_dir
    print_progress 100
else
    echo "Directory $root_dir does not exist."
    print_progress 100
fi

echo "User $username and all associated directories have been deleted."
