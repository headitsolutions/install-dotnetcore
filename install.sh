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
    echo 'export PATH="$PATH:$HOME/.dotnet"' >> ~/.bashrc
    source ~/.bashrc
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
if [ -z "$DOTNET_ROOT" ]; then
    echo 'export DOTNET_ROOT="$HOME/.dotnet"' >> ~/.bashrc
    export DOTNET_ROOT="$HOME/.dotnet"
fi

# Check if the PATH already has the .NET executables and tools directory
if [[ ":$PATH:" != *":$HOME/.dotnet:"* ]] || [[ ":$PATH:" != *":$HOME/.dotnet/tools:"* ]]; then
    echo 'export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"' >> ~/.bashrc
    export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"
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
