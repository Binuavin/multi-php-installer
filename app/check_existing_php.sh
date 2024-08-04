#!/bin/bash

check_existing_php_installations() {
    echo -e "Checking existing PHP installations...\n"
    
    if command -v php &> /dev/null; then

        active_version=$(php -v | grep -oP '(?<=PHP )\d+\.\d+\.\d+' | head -n1)
        active_major_version=$( echo "$active_version" | sed 's/\.[^.]*$//')
        # active_version=$(php -v | head -n 1 | awk '{print $2}')
        config_path=$(php --ini | grep "Loaded Configuration File" | awk '{print $4}')

        echo "Active CLI PHP version: $active_version"
        echo -e "PHP CLI Config file path: $config_path \n"

        if command -v apache2 &> /dev/null; then
            apache_php_version='' #TODO: Dynamically update Apache version
            echo -e "Active Apache2 PHP version: $active_version"   #TODO: Dynamically update Apache version
            echo -e "PHP Apache2 Config file path: /etc/php/$active_major_version/apache2/php.ini \n"   #TODO: Dynamically update Apache version
        fi

        echo "Other installed PHP versions:"

        installed_php_versions=$(update-alternatives --list php | awk -F'/php' '{print $2}' | sort -urV | tr '\n' ' ')

        for version in $installed_php_versions; do
            if [ "$version" != "$active_major_version" ]; then
                echo "- PHP $version"
            fi
        done
        true
    else
        echo "No PHP installations found."
        false
    fi
}