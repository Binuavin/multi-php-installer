#!/bin/bash

# Check if ncessary pacakges are installed
dependent_packages_install() {
    # WhipTail
    if ! command -v whiptail &> /dev/null; then
        echo "whiptail could not be found, installing..."
        sudo apt update > /dev/null
        sudo apt -qq install whiptail -y
    fi

    # Install JQ (https://jqlang.github.io/jq/) package if not already installed. 
    if [ ! -f /usr/bin/jq ]; then
        sudo apt update > /dev/null
        sudo apt -qq install jq >/dev/null
    fi
}
