#!/bin/bash
# Script Running and tested on OS Ubuntu 20.04 LTS
# Service Install
#    - Nginx Stable Version
#    - PHP-FPM 8.1
#    - MariaDB v10.11
#    - Certbot SSL

# Function to print progress
print_progress() {
    local progress=$1
    echo "======== Progress: ${progress}% ========"
}

# Update OS
echo "Updating OS..."
apt update -y && apt dist-upgrade -y > /dev/null 2>&1
print_progress 10

# Install Nginx Stable Version
echo "Installing Nginx dependencies..."
apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring > /dev/null 2>&1
print_progress 20

echo "Adding Nginx signing key..."
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null > /dev/null 2>&1
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null 2>&1
print_progress 30

echo "Adding Nginx repository..."
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list > /dev/null 2>&1
print_progress 35

echo "Setting Nginx repository priority..."
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx > /dev/null 2>&1
print_progress 40

echo "Updating package list and installing Nginx..."
apt update > /dev/null 2>&1
apt autoremove -y > /dev/null 2>&1
apt install -y nginx > /dev/null 2>&1
print_progress 50

# Install PHP Using Repo ondrej
echo "Installing software-properties-common..."
apt install -y software-properties-common > /dev/null 2>&1
print_progress 55

echo "Adding PHP repository..."
add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1
print_progress 60

echo "Updating package list before installing PHP 8.1..."
apt update > /dev/null 2>&1
print_progress 65

echo "Installing PHP 8.1..."
apt-get install -y php8.1 php8.1-fpm php8.1-common php8.1-cli php8.1-opcache php8.1-mysql php8.1-mbstring php8.1-curl php8.1-xml php8.1-gd php8.1-imagick php8.1-tidy php8.1-xmlrpc php8.1-intl php8.1-xsl php8.1-zip php8.1-soap php8.1-bcmath php8.1-ldap php8.1-readline php8.1-bz2 php8.1-sqlite3 php8.1-redis > /dev/null 2>&1
print_progress 70

# Configure PHP-FPM 8.1
echo "Configuring PHP-FPM 8.1..."
sed -i 's/^listen = \/run\/php\/php8.1-fpm.sock/;listen = \/run\/php\/php8.1-fpm.sock/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/;listen = \/run\/php\/php8.1-fpm.sock/listen = 127.0.0.1:9000/' /etc/php/8.1/fpm/pool.d/www.conf
print_progress 75

echo "Restarting and enabling Nginx and PHP-FPM services..."
systemctl restart nginx php8.1-fpm > /dev/null 2>&1
systemctl enable nginx php8.1-fpm > /dev/null 2>&1
print_progress 80

# Install Database MariaDB v.10.11 for Ubuntu 20.04
echo "Installing MariaDB dependencies..."
apt-get install -y apt-transport-https curl software-properties-common > /dev/null 2>&1
print_progress 85

echo "Creating keyrings directory..."
mkdir -p /etc/apt/keyrings > /dev/null 2>&1
print_progress 87

echo "Adding MariaDB keyring..."
curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp' > /dev/null 2>&1
print_progress 90

echo "Adding MariaDB repository for Ubuntu 20.04..."
cat <<EOF | tee /etc/apt/sources.list.d/mariadb.sources > /dev/null 2>&1
# MariaDB 10.11 repository list - created $(date -u +"%Y-%m-%d %H:%M UTC")
# https://mariadb.org/download/
X-Repolib-Name: MariaDB
Types: deb
URIs: https://mirror.rackspace.com/mariadb/repo/10.11/ubuntu
Suites: focal
Components: main main/debug
Signed-By: /etc/apt/keyrings/mariadb-keyring.pgp
EOF
print_progress 92

echo "Updating package list and installing MariaDB..."
apt update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server > /dev/null 2>&1
print_progress 97

echo "Enabling and starting MariaDB service..."
systemctl enable mariadb > /dev/null 2>&1
systemctl start mariadb > /dev/null 2>&1
print_progress 98

# Install Certbot and Certbot Nginx
echo "Installing Certbot and Certbot Nginx..."
apt install -y certbot python3-certbot-nginx > /dev/null 2>&1
print_progress 100

echo "======== Checking status of service installed ========"
systemctl status mariadb | grep Active
systemctl status nginx | grep Active
systemctl status php8.1-fpm | grep Active
