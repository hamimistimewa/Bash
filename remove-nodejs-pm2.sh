#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# Service Uninstall
#    - Nodejs 
#    - pm2 (latest version)

# Function to remove all Node.js, PM2, and NVM components

remove_nvm_components() {
    echo "Stopping all running PM2 processes ..."
    pm2 kill

    echo "Uninstalling PM2 and Node.js ..."
    npm uninstall -g pm2
    nvm uninstall node

    echo "Removing NVM setup from current shell ..."
    unset NVM_DIR
    [ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" && nvm deactivate

    echo "Removing NVM setup from ~/.bashrc ..."
    sed -i '/nvm/d' ~/.bashrc

    echo "Removing ~/.nvm directory ..."
    rm -rf "$HOME/.nvm"

    echo "All Node.js, PM2, and NVM components have been uninstalled and configurations removed."
}

# Call the function to remove components
remove_nvm_components
