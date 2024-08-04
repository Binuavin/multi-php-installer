#!/bin/bash

switch_active_php() {
    installed_versions=$(update-alternatives --list php | awk -F'/php' '{print $2}' | sort -urV | tr '\n' ' ')
    options=""
    
    for version in $installed_versions; do
        options="$options $version PHP $version OFF"
    done
    
    selected_version=$(whiptail --radiolist "Select the PHP version to activate:" 15 60 5 $options 3>&1 1>&2 2>&3)
    
    if [ -n "$selected_version" ]; then
        sudo update-alternatives --set php /usr/bin/php$selected_version
        echo "Switched to PHP $selected_version"
    else
        echo "No version selected. Active PHP version remains unchanged."
    fi
}