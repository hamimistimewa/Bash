#!/bin/bash
#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# - Anda dapat menambahkan user baru 
# - Script ini sekaligus melakukan konfigurasi permission and owner mengikuti user yang dibuat

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
read -p "Enter the username you want to add: " username

# Add user and set permissions
echo "Adding user $username..."
useradd -m -s /bin/bash $username
print_progress 10

# Set password for the new user
read -sp "Enter the password for $username: " password
echo
echo "$username:$password" | chpasswd
print_progress 15

echo "Adding $username to sudo and www-data groups..."
usermod -aG www-data $username
usermod -aG sudo $username
print_progress 20

# Get the root directory
read -p "Enter the root directory (e.g., /var/www/html/domain.com/public): " root_dir

# Create the directory if it does not exist
echo "Creating directory $root_dir..."
mkdir -p $root_dir
print_progress 30

# Set permissions
echo "Setting directory and file permissions..."
find $root_dir -type d -exec chmod 775 {} \;
find $root_dir -type f -exec chmod 664 {} \;
find $root_dir -type d -exec chmod g+s {} \+
print_progress 60

# Set ownership
echo "Setting ownership..."
chown www-data:www-data $(dirname $root_dir)
chown $username:www-data $root_dir
print_progress 100

echo "User $username has been added and directory $root_dir has been configured."