#!/bin/bash

# Function to check if dotnet core 7 is installed
is_dotnet_core_7_installed() {
    if command -v dotnet >/dev/null 2>&1; then
        version=$(dotnet --version)
        if [[ $version == 7.* ]]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

# Function to install dotnet core 7
install_dotnet_core_7() {
    wget https://dot.net/v1/dotnet-install.sh
    chmod +x dotnet-install.sh
    ./dotnet-install.sh --version 7.0.0 # specify the exact version if you know it
    echo 'export PATH="$PATH:$HOME/.dotnet"' >> ~/.bashrc # or ~/.bash_profile or ~/.zshrc
    source ~/.bashrc # or source ~/.bash_profile or source ~/.zshrc
}

# Main script logic

# Check if dotnet core 7 is installed
if is_dotnet_core_7_installed; then
    echo ".NET Core 7 is already installed."
else
    echo ".NET Core 7 is not installed."
    echo "Installing .NET Core 7..."
    install_dotnet_core_7
fi
