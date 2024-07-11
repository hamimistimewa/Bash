#!/bin/bash
# Script Running and tested on OS Ubuntu 20.04 LTS and 22.04 LTS
# Service to Uninstall
#    - Nginx Stable Version
#    - PHP-FPM 8.1
#    - MariaDB v10.11
#    - Certbot SSL

# Function to print progress
print_progress() {
    local progress=$1
    echo "======== Progress: ${progress}% ========"
}

# Uninstall Certbot and Certbot Nginx
echo "Uninstalling Certbot and Certbot Nginx..."
apt-get purge -y certbot python3-certbot-nginx > /dev/null 2>&1
print_progress 10

# Uninstall MariaDB v10.11
echo "Stopping MariaDB service..."
systemctl stop mariadb > /dev/null 2>&1
print_progress 20

echo "Disabling MariaDB service..."
systemctl disable mariadb > /dev/null 2>&1
print_progress 30

echo "Uninstalling MariaDB server..."
apt-get purge -y mariadb-server > /dev/null 2>&1
print_progress 40

echo "Removing MariaDB repository and keyrings..."
rm -f /etc/apt/sources.list.d/mariadb.sources
rm -f /etc/apt/keyrings/mariadb-keyring.pgp
print_progress 50

# Uninstall PHP-FPM 8.1
echo "Stopping PHP-FPM service..."
systemctl stop php8.1-fpm > /dev/null 2>&1
print_progress 60

echo "Disabling PHP-FPM service..."
systemctl disable php8.1-fpm > /dev/null 2>&1
print_progress 70

echo "Uninstalling PHP 8.1 and related packages..."
apt-get purge -y php8.1 php8.1-fpm php8.1-common php8.1-cli php8.1-opcache php8.1-mysql php8.1-mbstring php8.1-curl php8.1-xml php8.1-gd php8.1-imagick php8.1-tidy php8.1-xmlrpc php8.1-intl php8.1-xsl php8.1-zip php8.1-soap php8.1-bcmath php8.1-ldap php8.1-readline php8.1-bz2 php8.1-sqlite3 php8.1-redis > /dev/null 2>&1
print_progress 80

echo "Removing PHP repository..."
add-apt-repository --remove ppa:ondrej/php -y > /dev/null 2>&1
print_progress 85

# Uninstall Nginx Stable Version
echo "Stopping Nginx service..."
systemctl stop nginx > /dev/null 2>&1
print_progress 87

echo "Disabling Nginx service..."
systemctl disable nginx > /dev/null 2>&1
print_progress 90

echo "Uninstalling Nginx..."
apt-get purge -y nginx > /dev/null 2>&1
print_progress 95

echo "Removing Nginx repository and keyrings..."
rm -f /etc/apt/sources.list.d/nginx.list
rm -f /usr/share/keyrings/nginx-archive-keyring.gpg
print_progress 98

# Clean up remaining dependencies and autoremove packages
echo "Cleaning up remaining dependencies..."
apt-get autoremove -y > /dev/null 2>&1
apt-get clean > /dev/null 2>&1
print_progress 100

# Remove default directories for services
echo "Removing default directories for services..."
rm -rf /etc/nginx
rm -rf /etc/php
rm -rf /var/lib/mysql
rm -rf /etc/letsencrypt
rm -rf /var/www/html

echo "Uninstallation complete."
