#!/bin/sh

# Author : n00b

#Set up MariaDB repositories

apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror.netinch.com/pub/mariadb/repo/10.4/ubuntu focal main'

#Install base packages
apt-get update; apt-get install -y build-essential curl nano wget lftp unzip bzip2 arj nomarch lzop htop openssl gcc git binutils libmcrypt4 libpcre3-dev make python3 python3-pip supervisor unattended-upgrades whois zsh imagemagick uuid-runtime net-tools

# install nginx
apt install nginx -y
systemctl enable nginx
systemctl start nginx


#Install PHP7.4 and common PHP packages
echo "Install PHP 7.4"
apt install -y php7.4 php7.4-fpm php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl
systemctl enable php7.4-fpm
systemctl start php7.4-fpm

#Install MariaDB (MySQL) and set a strong root password

apt-get install -y mariadb-server;
systemctl enable mariadb
systemctl start mariadb

#Setup unattended security upgrades
cat > /etc/apt/apt.conf.d/10periodic << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
