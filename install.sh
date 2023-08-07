#!/bin/bash

# Function to check if dotnet core 7 SDK is installed
is_dotnet_core_7_sdk_installed() {
    if command -v dotnet >/dev/null 2>&1; then
        version=$(dotnet --list-sdks | grep '^7')
        if [[ $version == 7.* ]]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

# Function to check if dotnet core 7 runtime is installed
is_dotnet_core_7_runtime_installed() {
    if command -v dotnet >/dev/null 2>&1; then
        version=$(dotnet --list-runtimes | grep 'Microsoft.AspNetCore.App' | grep -Eo '7\.[0-9]+')
        if [[ $version == 7.* ]]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

# Function to install dotnet core 7 SDK
install_dotnet_core_7_sdk() {
    wget https://dot.net/v1/dotnet-install.sh
    chmod +x dotnet-install.sh
    ./dotnet-install.sh --channel 7.0
}

# Function to install dotnet core 7 runtime
install_dotnet_core_7_runtime() {
    sudo apt-get update && sudo apt-get install -y aspnetcore-runtime-7.0
}

# Main script logic

# Check if dotnet core 7 SDK is installed
if is_dotnet_core_7_sdk_installed; then
    echo ".NET Core 7 SDK is already installed."
else
    echo ".NET Core 7 SDK is not installed."
    echo "Installing .NET Core 7 SDK..."
    install_dotnet_core_7_sdk
fi

# Check and set the DOTNET_ROOT environment variable if it's not already set
if [[ ":$PATH:" != *":$HOME/.dotnet:"* ]]; then
    export PATH="$PATH:$HOME/.dotnet"
fi

if [[ ":$PATH:" != *":$HOME/.dotnet/tools:"* ]]; then
    export PATH="$PATH:$HOME/.dotnet/tools"
fi

# Check if dotnet core 7 runtime is installed
if is_dotnet_core_7_runtime_installed; then
    echo ".NET Core 7 runtime is already installed."
else
    echo ".NET Core 7 runtime is not installed."
    echo "Installing .NET Core 7 runtime..."
    install_dotnet_core_7_runtime
fi

# Apply the changes made to ~/.bashrc immediately to the current session
source ~/.bashrc
