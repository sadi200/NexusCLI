#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Red
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Yellow
NC='\033[0m'        # No Color

# Display social details and channel information in large letters manually
echo "========================================"
echo -e "${GREEN} Script is made by EARNPOINT${NC}"
echo -e "-------------------------------------"

echo -e ""
echo -e ""
echo -e '\e[34m'
echo -e '████████  ████████   '
echo -e '██        ██    ██         '
echo -e '████████  ████████      '
echo -e '██        ██     '
echo -e '████████  ██     '
echo -e '                                                   '
echo -e '\e[0m'
echo -e "Join our Telegram channel: https://t.me/Earnpoint10"
 
echo "======================================================="

echo "======================================================="

# Update your system
echo -e "${INFO}Updating your system...${NC}"
sudo apt update -y

# Check if screen is installed, and install it if not
if ! command -v screen &> /dev/null; then
    echo -e "${INFO}Screen is not installed. Installing Screen...${NC}"
    sudo apt install screen -y
else
    echo -e "${INFO}Screen is already installed. Skipping installation.${NC}"
fi

# Install protobuf-compiler
echo -e "${INFO}Installing protobuf-compiler...${NC}"
sudo apt install protobuf-compiler -y

# Reinstall pkg-config
echo -e "${INFO}Reinstalling pkg-config...${NC}"
sudo apt install --reinstall pkg-config -y

# Check if git is installed, and install it if not
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git is not installed. Installing Git...${NC}"
    sudo apt install git -y
else
    echo -e "${INFO}Git is already installed. Skipping installation.${NC}"
fi

# Define the location where Rust will be installed
RUSTUP_HOME="$HOME/.rustup"
CARGO_HOME="$HOME/.cargo"

# Load Rust environment variables
load_rust() {
    export RUSTUP_HOME="$HOME/.rustup"
    export CARGO_HOME="$HOME/.cargo"
    export PATH="$CARGO_HOME/bin:$PATH"
    # Source the environment variables for the current session
    if [ -f "$CARGO_HOME/env" ]; then
        source "$CARGO_HOME/env"
    fi
}

# Function to install system dependencies required for Rust
install_dependencies() {
    echo -e "${YELLOW} Installing system dependencies required for Rust...${NC}"
    sudo apt update && sudo apt install -y build-essential libssl-dev curl
}

# Install system dependencies before checking for Rust
install_dependencies

# Check if Rust is already installed
if command -v rustup &> /dev/null; then
    echo "Rust is already installed."
    read -p "Do you want to reinstall or update Rust? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
        echo "Reinstalling Rust..."
        rustup self uninstall -y
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
else
    echo -e "${YELLOW} Rust is not installed. Installing Rust...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Load Rust environment after installation
load_rust 

# Fix permissions for Rust directories (using sudo for root access)
echo "Ensuring correct permissions for Rust directories..."
if [ -d "$RUSTUP_HOME" ]; then
    sudo chmod -R 755 "$RUSTUP_HOME"
fi

if [ -d "$CARGO_HOME" ]; then
    sudo chmod -R 755 "$CARGO_HOME"
fi

# Function to retry sourcing environment if Cargo is not found
retry_cargo() {
    local max_retries=3
    local retry_count=0
    local cargo_found=false

    while [ $retry_count -lt $max_retries ]; do
        if command -v cargo &> /dev/null; then
            cargo_found=true
            break
        else
            echo "Cargo not found in the current session. Attempting to reload the environment..."
            source "$CARGO_HOME/env"
            retry_count=$((retry_count + 1))
        fi
    done

    if [ "$cargo_found" = false ]; then
        echo "Error: Cargo is still not recognized after $max_retries attempts."
        echo "Please manually source the environment by running: source \$HOME/.cargo/env"
        return 1
    fi

    echo "Cargo is available in the current session."
    return 0
}

# Retry checking for Cargo availability
retry_cargo
if [ $? -ne 0 ]; then
    exit 1
fi

# Display thank you message
echo "==================================="
echo -e "${RED}        EARNPOINT      ${NC}"
echo "==================================="
echo "========================================"
echo -e "${RED} Thanks for using the script${NC}"
echo -e "-------------------------------------"
