#!/bin/bash

set -e

# Function to detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/fedora-release ]; then
        echo "fedora"
    else
        echo "unknown"
    fi
}

# Function to install keyd based on the distribution
install_keyd() {
    local distro=$(detect_distro)

    case "$distro" in
        "arch"|"manjaro"|"endeavouros"|"cachyos")
            echo "Installing keyd on Arch-based system..."
            if pacman -Ss ^keyd$ | grep -q "keyd"; then
                sudo pacman -S --needed keyd
            else
                sudo pacman -S --needed base-devel git
                git clone https://github.com/rvaiya/keyd
                cd keyd
                make && sudo make install
                cd ..
                rm -rf keyd
            fi
            ;;

        "ubuntu"|"debian"|"pop"|"linuxmint")
            echo "Installing keyd on Debian-based system..."
            # Try to install from package manager first
            if apt-cache show keyd 2>/dev/null; then
                sudo apt-get update
                sudo apt-get install -y keyd
            else
                sudo apt-get update
                sudo apt-get install -y git build-essential
                git clone https://github.com/rvaiya/keyd
                cd keyd
                make && sudo make install
                cd ..
                rm -rf keyd
            fi
            ;;

        "fedora"|"centos"|"rhel")
            echo "Installing keyd on Fedora-based system..."
            # Try to install from package manager first
            if dnf list keyd &>/dev/null; then
                sudo dnf install -y keyd
            else
                sudo dnf groupinstall -y "Development Tools"
                sudo dnf install -y git
                git clone https://github.com/rvaiya/keyd
                cd keyd
                make && sudo make install
                cd ..
                rm -rf keyd
            fi
            ;;

        *)
            echo "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
}

# Function to configure keyd
configure_keyd() {
    # Create keyd config directory if it doesn't exist
    sudo mkdir -p /etc/keyd

    # Copy the configuration file
    echo "Copying keyd configuration..."
    sudo cp "$(dirname "$(dirname "$0")")/configs/keyd/default.conf" /etc/keyd/default.conf

    # Set proper permissions
    sudo chmod 644 /etc/keyd/default.conf

    # Enable and start keyd service
    echo "Enabling and starting keyd service..."
    sudo systemctl enable keyd
    sudo systemctl restart keyd
}

# Main execution
echo "Installing keyd..."
install_keyd

echo "Configuring keyd..."
configure_keyd

echo "keyd has been installed and configured successfully!"
echo "Your custom key mappings should now be active."

