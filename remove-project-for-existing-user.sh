#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# - Script ini akan menghapus project yang telah dibuat tapi tidak menghapus user existing yang ada dan masih digunakan

# Function to print progress
print_progress() {
    local progress=$1
    echo "======== Progress: ${progress}% ========"
}

# Function to delete Nginx config
delete_nginx_config() {
    local domain=$1
    rm -f /etc/nginx/conf.d/$domain.conf
}

# Function to delete project directory
delete_project_directory() {
    local root_dir=$1
    rm -rf $root_dir
}

# Function to prompt for confirmation
confirm_action() {
    read -p "Pastikan input dengan benar, apakah Anda yakin untuk melanjutkan? (yes/no): " confirm
    case $confirm in
        [Yy][Ee][Ss]|[Yy])
            return 0
            ;;
        [Nn][Oo]|[Nn])
            return 1
            ;;
        *)
            echo "Pilihan tidak valid. Silakan masukkan 'yes' untuk melanjutkan atau 'no' untuk membatalkan."
            confirm_action
            ;;
    esac
}

# Main script
read -p "Enter the domain name to delete (e.g., example.com or sub.example.com): " domain
read -p "Enter the root directory of the project to delete (e.g., /var/www/html/domain.com/public): " root_dir

# Check if www is only for main domains, not subdomains
if [[ $domain == www.* ]]; then
    domain=$(echo $domain | cut -c 5-)
fi

# Confirm deletion action
confirm_action
if [ $? -eq 0 ]; then
    # Delete Nginx configuration
    delete_nginx_config "$domain"

    # Delete project directory
    delete_project_directory "$root_dir"

    # Check Nginx configuration after deletion
    nginx -t
    if [ $? -eq 0 ]; then
        echo "Config Nginx normal. Reloading Nginx..."
        systemctl reload nginx
    else
        echo "Config Nginx ada kendala! Pastikan kembali sudah benar."
    fi

    print_progress 100
    echo "Project $domain has been deleted successfully."
else
    echo "Penghapusan dibatalkan."
fi
