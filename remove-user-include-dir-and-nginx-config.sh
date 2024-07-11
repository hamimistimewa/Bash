#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# - Script ini akan menghapus project yang telah dibuat sekaligus menghapus user-nya.

# Function to print progress
print_progress() {
    local progress=$1
    echo "======== Progress: ${progress}% ========"
}

# Function to check if a domain is a subdomain
is_subdomain() {
    local domain=$1
    if [[ $domain == *.*.* ]]; then
        return 0  # True, it's a subdomain
    else
        return 1  # False, it's not a subdomain
    fi
}

# Function to delete Nginx config
delete_nginx_config() {
    local domain=$1
    local config_file="/etc/nginx/conf.d/$domain.conf"

    if [ -f "$config_file" ]; then
        rm $config_file
        echo "Nginx configuration for $domain has been deleted."
    else
        echo "Nginx configuration for $domain not found."
    fi
}

# Function to delete user and its directories
delete_user_and_directories() {
    read -p "Enter the username to delete: " username
    read -p "Enter the root directory to delete (e.g., /var/www/html/domain.com/public): " root_dir

    userdel -r $username
    echo "User $username has been deleted."

    if [ -d "$root_dir" ]; then
        rm -rf $root_dir
        echo "Directory $root_dir has been deleted."
    else
        echo "Directory $root_dir not found."
    fi

    # Delete user's home directory
    user_home_dir=$(eval echo ~$username)
    if [ -d "$user_home_dir" ]; then
        rm -rf $user_home_dir
        echo "User's home directory $user_home_dir has been deleted."
    else
        echo "User's home directory $user_home_dir not found."
    fi
}

# Main script
delete_user_and_directories

read -p "Enter the domain name to delete Nginx config (e.g., example.com): " domain

delete_nginx_config $domain

# Check Nginx configuration before reload
nginx -t
if [ $? -eq 0 ]; then
    echo "Config Nginx normal. Reloading Nginx..."
    systemctl reload nginx
else
    echo "Config Nginx ada kendala! Pastikan kembali sudah benar."
fi

print_progress 100
echo "User and Nginx configuration for $domain have been deleted."
