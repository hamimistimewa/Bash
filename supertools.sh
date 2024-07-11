#!/bin/bash
# List Script yang dapat Anda gunakan sesuai kebutuhan Anda
# Gunakan Script ini dengan bijak

# Function to print menu
print_menu() {
    echo "===================="
    echo "Supertools MS Quel"
    echo "===================="
    echo
    echo "Pilih Service yang ingin Anda install"
    echo "---------------------------------------"
    echo "1. Install LEMP Stack on Ubuntu 20.04 LTS"
    echo "2. Install LEMP Stack on Ubuntu 22.04 LTS"
    echo "3. Install NodeJS and PM2 on Ubuntu 20.04, 22.04 LTS"
    echo "4. Remove LEMP Stack on Ubuntu 20.04 LTS or 22.04 LTS"
    echo "5. Remove NodeJS and PM2 on Ubuntu 20.04, 22.04 LTS"
    echo "6. Add New User, Directory and Permission, Owner on Ubuntu 20.04, 22.04 LTS"
    echo "7. Add New Project for New User on Ubuntu 20.00, 22.04 LTS"
    echo "8. Add New Project for Existing User on Ubuntu 20.00, 22.04 LTS"
    echo "9. Add Nginx Config Only For Domain or Subdomain on Ubuntu 20.00, 22.04 LTS"
    echo "10. Remove User and Directory on Ubuntu 20.04, 22.04 LTS"
    echo "11. Remove User Include Directory and Nginx Config on Ubuntu 20.04, 22.04 LTS"
    echo "12. Remove New Project for Existing User on Ubuntu 20.04, 22.04 LTS"
    echo "13. Keluar"
    echo
    echo "========================================================="
    echo
}

# Function to install LEMP Stack on Ubuntu 20.04 LTS
install_lemp_20_04_lts() {
    ./install-lemp-20-04-lts.sh
}

# Function to install LEMP Stack on Ubuntu 22.04 LTS
install_lemp_22_04_lts() {
    ./install-lemp-22-04-lts.sh
}

# Function to install NodeJS and PM2 on Ubuntu 20.04, 22.04 LTS
install_node_pm2() {
    ./install-lemp-nodejs-pm2.sh
}

# Function to Remove LEMP Stack on Ubuntu 20.04, 22.04 LTS
remove_lemp_on_ubuntu_20_and_22_lts() {
    ./remove-lemp-on-ubuntu-20-and-22-lts.sh
}

# Function to Remove nodejs and pm2 on Ubuntu 20.04, 22.04 LTS
remove_node_pm2() {
    ./remove-node-pm2-ubuntu.sh
}

# Function to Add New User, Directory and Permission, Owner on Ubuntu 20.04, 22.04 LTS
add_new_user_directory_permission() {
    ./add-new-user-directory-permission.sh
}

# Function to Add New Project for New User and Domain on Ubuntu 20.00, 22.04 LTS
add_new_project_for_new_user() {
    ./add-new-project-for-new-user.sh
}

# Function to Add New Project for Existing User on Ubuntu 20.00, 22.04 LTS
add_new_project_for_existing_user() {
    ./add-new-project-for-existing-user.sh
}

# Function to Add Nginx Config Only For Domain or Subdomain on Ubuntu 20.00, 22.04 LTS
add_nginx_config_only() {
    ./add-nginx-config-only.sh
}

# Function to Remove User and Directory on Ubuntu 20.04, 22.04 LTS
remove_user_and_directory() {
    ./remove-user-and-directory.sh
}

# Function to Remove User Include Directory and Nginx Config on Ubuntu 20.04, 22.04 LTS
remove_user_include_dir_and_nginx_config() {
    ./remove-user-include-dir-and-nginx-config.sh
}

# Function to Remove Project for Existing User on Ubuntu 20.04, 22.04 LTS
remove_project_for_existing_user() {
    ./remove-project-for-existing-user.sh
}

# Password protection
read -s -p "Enter password: " password
echo

if [[ "$password" != "abc1234" ]]; then
    echo "Password salah. Akses ditolak."
    exit 1
fi

# Main script execution starts here
while true; do
    print_menu
    read -p "Masukkan pilihan Anda [1-13]: " choice
    echo

    case $choice in
        1) install_lemp_20_04_lts ;;
        2) install_lemp_22_04_lts ;;
        3) install_node_pm2 ;;
        4) remove_lemp_on_ubuntu_20_and_22_lts ;;
        5) remove_node_pm2 ;;
        6) add_new_user_directory_permission ;;
        7) add_new_project_for_new_user ;;
        8) add_new_project_for_existing_user ;;
        9) add_nginx_config_only ;;
        10) remove_user_and_directory ;;
        11) remove_user_include_dir_and_nginx_config ;;
        12) remove_project_for_existing_user ;;
        13) echo "Terima kasih telah menggunakan Supertools. Sampai jumpa lagi!" ; break ;;
        *) echo "Pilihan tidak valid. Silakan masukkan nomor dari menu yang tersedia." ;;
    esac

    echo
done
