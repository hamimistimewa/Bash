#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# - Anda dapat menambahkan Project Baru sesuai requst customer
# - Tersedia configuration nginx untuk project HTML, PHP dan Nodejs atau Reverse_Proxy
# - Script ini tidak membuat user melainkan menggunakan user existing


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

# Function to create Nginx config for HTML
create_nginx_config_html() {
    local domain=$1
    local root_dir=$2

    cat <<EOF > /etc/nginx/conf.d/$domain.conf
server {
    server_name $domain;
    root $root_dir;
    index index.html;
    access_log /var/log/nginx/${domain}_access.log;
    error_log /var/log/nginx/${domain}_error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
    }
}
EOF
}

# Function to create Nginx config for PHP
create_nginx_config_php() {
    local domain=$1
    local root_dir=$2

    cat <<EOF > /etc/nginx/conf.d/$domain.conf
server {
    server_name www.$domain $domain;
    root $root_dir;
    index index.php index.html;
    access_log /var/log/nginx/${domain}_access.log;
    error_log /var/log/nginx/${domain}_error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_read_timeout 3600;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
    }
}
EOF
}

# Function to create Nginx config for Node.js / Reverse Proxy
create_nginx_config_nodejs() {
    local domain=$1
    local root_dir=$2
    local port=$3

    cat <<EOF > /etc/nginx/conf.d/$domain.conf
upstream $domain {
    server 127.0.0.1:$port;
}
server {
    server_name $domain;
    access_log /var/log/nginx/${domain}_access.log;
    error_log /var/log/nginx/${domain}_error.log;

    location / {
        proxy_pass http://$domain;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
}

# Function to set permissions and ownership
set_permissions_and_ownership() {
    local root_dir=$1
    local username=$2

    find $root_dir -type d -exec chmod 775 {} \;
    find $root_dir -type f -exec chmod 664 {} \;
    find $root_dir -type d -exec chmod g+s {} +

    chown www-data:www-data $(dirname $root_dir)
    chown $username:www-data $root_dir
}

# Main script
echo "Select the type of Nginx config:"
echo "1. HTML"
echo "2. PHP"
echo "3. Node.js / Reverse Proxy"
read -p "Enter your choice (1/2/3): " config_choice

read -p "Enter the domain name (e.g., example.com or sub.example.com): " domain
read -p "Enter the root directory (e.g., /var/www/html/domain.com/public): " root_dir

# Ensure www is only for main domains, not subdomains
if ! is_subdomain $domain; then
    domain="www.$domain $domain"
fi

case $config_choice in
    1)
        create_nginx_config_html "$domain" "$root_dir"
        ;;
    2)
        create_nginx_config_php "$domain" "$root_dir"
        ;;
    3)
        read -p "Enter the port number for the Node.js application: " port
        create_nginx_config_nodejs "$domain" "$root_dir" "$port"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Set permissions and ownership
read -p "Enter the existing username to set ownership: " username
set_permissions_and_ownership "$root_dir" "$username"

# Check Nginx configuration before reload
nginx -t
if [ $? -eq 0 ]; then
    echo "Config Nginx normal. Reloading Nginx..."
    systemctl reload nginx
else
    echo "Config Nginx ada kendala! Pastikan kembali sudah benar."
fi

print_progress 100
echo "Nginx configuration for $domain has been created and reloaded successfully."
