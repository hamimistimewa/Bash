#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# - Jika butuh configuration nginx bisa menggunakan fitur ini

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
create_html_config() {
    local domain=$1
    local root_dir=$2
    local server_name

    if is_subdomain $domain; then
        server_name="$domain"
    else
        server_name="$domain www.$domain"
    fi

    cat <<EOF > /etc/nginx/conf.d/$domain.conf
server {
    server_name $server_name;
    root    $root_dir;
    index  index.html index.php;
    access_log /var/log/nginx/$domain.access.log;
    error_log /var/log/nginx/$domain.error.log;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
        fastcgi_read_timeout 3600;
    }

    location ~*  \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
    }
}
EOF
}

# Function to create Nginx config for PHP
create_php_config() {
    local domain=$1
    local root_dir=$2
    local server_name

    if is_subdomain $domain; then
        server_name="$domain"
    else
        server_name="$domain www.$domain"
    fi

    cat <<EOF > /etc/nginx/conf.d/$domain.conf
server {
    server_name $server_name;
    root    $root_dir;
    index  index.php index.html;
    access_log /var/log/nginx/$domain.access.log;
    error_log /var/log/nginx/$domain.error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
        fastcgi_read_timeout 3600;
    }

    location ~*  \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
    }
}
EOF
}

# Function to create Nginx config for Node.js/Reverse Proxy
create_nodejs_config() {
    local domain=$1
    local port=$2
    local server_name

    if is_subdomain $domain; then
        server_name="$domain"
    else
        server_name="$domain www.$domain"
    fi

    cat <<EOF > /etc/nginx/conf.d/$domain.conf
upstream $domain {
    server 127.0.0.1:$port;
}
server {
    server_name $server_name;
    access_log /var/log/nginx/$domain.access.log;
    error_log /var/log/nginx/$domain.error.log;

    location / {
        proxy_pass http://$domain;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
}

echo "Choose the type of Nginx configuration:"
echo "1. HTML"
echo "2. PHP"
echo "3. Node.js / Reverse Proxy"
read -p "Enter your choice (1/2/3): " config_type

read -p "Enter the domain name (e.g., example.com): " domain
read -p "Enter the root directory (e.g., /var/www/html/example.com/public): " root_dir

case $config_type in
    1)
        create_html_config $domain $root_dir
        ;;
    2)
        create_php_config $domain $root_dir
        ;;
    3)
        read -p "Enter the port for the Node.js application: " port
        create_nodejs_config $domain $port
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Check Nginx configuration before reload
nginx -t
if [ $? -eq 0 ]; then
    echo "Config Nginx normal. Reloading Nginx..."
    systemctl reload nginx
else
    echo "Config Nginx ada kendala! Pastikan kembali sudah benar."
fi

print_progress 100
echo "Nginx configuration for $domain has been added."