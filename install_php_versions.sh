#!/bin/bash

source ./app/show_progress.sh

install_php_versions() {
    local versions_to_inst="$1"
    local installed_php_vers="$2"

    local total_steps=5
    local current_step=0

    {
        current_step=$((current_step + 1)) 
        show_progress "$current_step" "$total_steps"
        echo "### Updating system packages..."
        sudo apt -qq update
        
        current_step=$((current_step + 1))
        show_progress "$current_step" "$total_steps"
        echo "### Installing required packages..."
        sudo apt -qq install lsb-release ca-certificates apt-transport-https software-properties-common -y
        
        current_step=$((current_step + 1))
        show_progress "$current_step" "$total_steps"
        echo "### Adding PHP repository..."
        # sudo add-apt-repository ppa:ondrej/php -y
        sudo apt -qq update
        
        current_step=$((current_step + 1))
        show_progress "$current_step" "$total_steps"
        echo "### Installing selected PHP versions..."
        # for version in $versions; do
        #     sudo apt install php$version -y
        # done
        
        current_step=$((current_step + 1))
        show_progress "$current_step" "$total_steps"
        echo "### Installation complete!"
    }

}

install_php_versions