#!/bin/bash

# readonly SELF_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# printf "This script located in [%s]\n" "$SELF_DIR"

# Source other script files
source ./app/get_input.sh
source ./app/check_existing_php.sh
source ./app/confirm_install.sh
source ./app/download_php_versions.sh
source ./app/packages_install.sh
source ./app/switch_active_php.sh
source ./app/show_available_php_versions_copy.sh

# source install_php_versions.sh

# Main function
main() {
    #Installing whiptail package if not already installed
    dependent_packages_install

    # Check for exisiting PHP installations on system
    check_existing_php_installations
    is_installed_php=$?

    # Based on the PHP installations ask for Install new or other verisons
    # install_php='n'
    if [ $is_installed_php ]; then
        install_php=$(get_yn_input "Would you like to install other PHP Version now?")
    else
        install_php=$(get_yn_input "Would you like to install PHP now?")
    fi

    if [ $install_php == 0 ]; then
    # if [ "$1" == "--install" ] || "${install_php,,}" == "y" || "${install_other_php,,}" == "y" || confirm_installation; then
        echo -e "Preparing to install other PHP versions... \n"
        sleep 1

        # Download PHP versions to file
        downl_php_versions_info
        php_versions_file_exists=$?

        if [ $php_versions_file_exists ]; then
            #Show Modal to display major versions
            versions_to_install=$(show_available_php_versions)
            cancel_status=$?

            # TODO: Process Selected Versions
            if [ $cancel_status -eq 0 ]; then
            # if [ -n "$versions_to_install" ]; then
                echo "PHP Versions Selected. Installing."
                echo "$versions_to_install"
                # install_php_versions "$versions_to_install" "$installed_php_versions"
                # switch_active_php
            else
                echo "Installation Cancelled. Exiting."
                exit 1
            fi
        fi

    else
        echo "Installation cancelled."
        exit 1
    fi

}

# Run the main function
main "$@"