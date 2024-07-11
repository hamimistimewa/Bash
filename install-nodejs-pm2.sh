#!/bin/bash
# Script Running and tested on OS Ubuntu 22.04 LTS and 20.04 LTS
# Service Install
#    - Nodejs (pilih sendiri versinya)
#    - pm2 (latest version)

#!/bin/bash

# Function to display available LTS Node.js versions
display_node_versions() {
    echo "Available LTS Node.js versions:"
    curl -s https://nodejs.org/dist/index.tab | awk 'NR > 1 {print "  " $1}'
}

# Function to install Node.js using NVM
install_nodejs() {
    local node_version="$1"

    # Install NVM if not already installed
    if ! command -v nvm &> /dev/null; then
        echo "Installing NVM ..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        source ~/.nvm/nvm.sh
    fi

    echo "Installing Node.js version $node_version ..."
    nvm install "$node_version"

    if [ $? -ne 0 ]; then
        echo "Failed to install Node.js version $node_version"
        exit 1
    fi
    
    nvm alias default "$node_version"

    echo "Node.js version installed:"
    node -v
}

# Function to install PM2 (latest version)
install_pm2() {
    echo "Installing PM2 (latest version) ..."
    npm install -g pm2@latest

    if [ $? -ne 0 ]; then
        echo "Failed to install PM2"
        exit 1
    fi

    echo "PM2 version installed:"
    pm2 -v
}

# Function to set NVM and PATH in bash profile
set_nvm_in_bashrc() {
    echo "Setting up NVM and PATH in ~/.bashrc ..."

    if ! grep -q "source ~/.nvm/nvm.sh" ~/.bashrc; then
        echo 'source ~/.nvm/nvm.sh' >> ~/.bashrc
    fi

    if ! grep -q 'export PATH="$PATH:$(npm -g bin)"' ~/.bashrc; then
        echo 'export PATH="$PATH:$(npm -g bin)"' >> ~/.bashrc
    fi
}

# Main script execution starts here

# Display prompt to select Node.js version
display_node_versions
echo -n "Enter the Node.js version you want to install (e.g., v16, v14): "
read NODE_VERSION

# Install Node.js using NVM
install_nodejs "$NODE_VERSION"

# Install PM2 (latest version)
install_pm2

# Set up NVM and PATH in ~/.bashrc for future sessions
set_nvm_in_bashrc

# End of script
