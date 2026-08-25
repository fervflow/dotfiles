#!/bin/bash

# This script configures keyboards using the hid_apple driver.
# - Sets F1-F12 keys to standard mode by default.
# - Swaps Alt and Super keys for a standard PC layout.
# - Works on Arch, Debian, Ubuntu, Fedora, and derivatives.

set -e

CONF_FILE="/etc/modprobe.d/hid_apple.conf"

# Check for hid_apple module
check_module() {
    echo "Checking for hid_apple module..."
    if ! lsmod | grep -q "^hid_apple" && ! modinfo hid_apple >/dev/null 2>&1; then
        echo "Error: hid_apple module not found on this system."
        echo "This script is only for keyboards that use the Apple HID driver."
        exit 1
    fi

    # Try to load it if not currently active
    if ! lsmod | grep -q "^hid_apple"; then
        echo "hid_apple is not loaded. Attempting to load it..."
        sudo modprobe hid_apple || { echo "Failed to load hid_apple."; exit 1; }
    fi
}

# Function to detect distro and update initramfs
update_initramfs() {
    if command -v update-initramfs >/dev/null 2>&1; then
        echo "Updating initramfs (Debian/Ubuntu/Mint)..."
        sudo update-initramfs -u -k all
    elif command -v mkinitcpio >/dev/null 2>&1; then
        echo "Updating initramfs (Arch/Manjaro)..."
        sudo mkinitcpio -P
    elif command -v dracut >/dev/null 2>&1; then
        echo "Updating initramfs (Fedora/CentOS/RHEL)..."
        sudo dracut --force
    else
        echo "Warning: No initramfs update command found. Please reboot to ensure changes apply."
    fi
}

apply_changes() {
    local fn=$1
    local swap=$2
    local options="options hid_apple"

    check_module

    if [ "$fn" = true ]; then
        options="$options fnmode=2"
        if [ -e /sys/module/hid_apple/parameters/fnmode ]; then
            echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode > /dev/null
        fi
        echo "Enabled: F1-F12 as standard function keys."
    fi

    if [ "$swap" = true ]; then
        options="$options swap_opt_cmd=1"
        if [ -e /sys/module/hid_apple/parameters/swap_opt_cmd ]; then
            echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd > /dev/null
        fi
        echo "Enabled: Swapped Alt and Super (Windows) keys."
    fi

    echo "Applying configuration to $CONF_FILE..."
    echo "$options" | sudo tee "$CONF_FILE" > /dev/null
    update_initramfs
    echo "Configuration successful."
}

revert_changes() {
    if [ -f "$CONF_FILE" ]; then
        echo "Removing configuration file $CONF_FILE..."
        sudo rm "$CONF_FILE"
        
        # Reset live parameters to defaults if module is loaded
        if lsmod | grep -q "^hid_apple"; then
            [ -e /sys/module/hid_apple/parameters/fnmode ] && echo 1 | sudo tee /sys/module/hid_apple/parameters/fnmode > /dev/null
            [ -e /sys/module/hid_apple/parameters/swap_opt_cmd ] && echo 0 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd > /dev/null
        fi
        
        update_initramfs
        echo "All changes reverted."
    else
        echo "No configuration file found. System is already at default."
    fi
}

show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  (none)       Apply both FN keys fix and Alt/Super swap"
    echo "  --fn-only    Only fix the Function keys (F1-F12)"
    echo "  --swap-only  Only swap Alt and Super keys"
    echo "  --revert     Remove all changes made by this script"
    echo "  --help       Show this help message"
}

# Main Logic
case "$1" in
    --revert)
        revert_changes
        ;;
    --fn-only)
        apply_changes true false
        ;;
    --swap-only)
        apply_changes false true
        ;;
    --help)
        show_help
        ;;
    "")
        apply_changes true true
        ;;
    *)
        echo "Invalid option: $1"
        show_help
        exit 1
        ;;
esac

