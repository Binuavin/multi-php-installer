#!/bin/bash

# Function to Show Available PHP versions in a Modal
show_available_php_versions() {
    if [ ! -f "php_versions.json" ]; then
        echo "Error: php_versions.json file not found."
        exit 1
    fi

    PHP_VERS_INFO=$(cat php_versions.json)
    PHP_MAJOR_VERS=$(echo "$PHP_VERS_INFO" | jq -r '.php | keys | sort | reverse | .[]')

    # Handling the main-versions 8,7,5 .
    while true; do
        OPTIONS_DIALOG="" 
        first_iteration=true
        for i in $PHP_MAJOR_VERS; do 
            if $first_iteration; then
                OPTIONS_DIALOG+="$i PHP-$i ON "
                first_iteration=false
            else
                OPTIONS_DIALOG+="$i PHP-$i OFF "
            fi
        done

        SELECTED_PHP_RELEASE=$(whiptail --title "Select PHP Release (1)" --notags --checklist \
        "Select options using Space key and navigate with Arrow keys" 15 50 4 \
        $OPTIONS_DIALOG 3>&1 1>&2 2>&3)

        # Check if user cancelled
        if [ $? -ne 0 ]; then
            echo "Cancelled at step 1."
            return 1
        fi

        SELECTED_PHP_RELEASE=$(echo $SELECTED_PHP_RELEASE | tr -d '"')

        # Check if user selected at least one option
        if [ -z "$SELECTED_PHP_RELEASE" ]; then
            echo "No PHP Release selected. Please select at least one option."
            whiptail --title "Warning" --msgbox "Please select at least one PHP release." 8 45
        else
            echo "Selected PHP Release(s): $SELECTED_PHP_RELEASE"
            break
        fi
    done

    # Handling the sub-versions 8.0, 8.1, ..
    while true; do 
        SELECTED_PHP_SUBRELEASE=""
        for i in $SELECTED_PHP_RELEASE; do
            SELECTED_PHP_SUBRELEASE+=$(jq -r --arg version "$i" '.php[$version] | keys | sort | reverse | .[]' <<< "$PHP_VERS_INFO")
            SELECTED_PHP_SUBRELEASE+=" "
        done

        OPTIONS_DIALOG="" 
        for i in $SELECTED_PHP_SUBRELEASE; do
            OPTIONS_DIALOG+="$i PHP-$i OFF "
        done

        SELECTED_PHP_SUB_VER_RELEASE=$(whiptail --title "Select PHP Version Category" --notags --checklist \
        "Select options using Space key and navigate with Arrow keys" 15 50 4 \
        $OPTIONS_DIALOG 3>&1 1>&2 2>&3)

        # Check if user cancelled
        if [ $? -ne 0 ]; then
            echo "Cancelled at step 2."
            return 1
        fi

        SELECTED_PHP_SUB_VER_RELEASE=$(echo $SELECTED_PHP_SUB_VER_RELEASE | tr -d '"')

        # Check if user selected at least one option
        if [ -z "$SELECTED_PHP_SUB_VER_RELEASE" ]; then
            echo "No PHP Version Category selected. Please select at least one option."
            whiptail --title "Warning" --msgbox "Please select at least one PHP version category." 8 45
        else
            echo "Selected PHP Version Category(ies): $SELECTED_PHP_SUB_VER_RELEASE"
            break
        fi
    done

    # Handling the last-versions 8.0.2, 8.1.3, ..
    while true; do 
        SELECTED_PHP_SUB_LAST_VER_RELEASE=""
        for i in $SELECTED_PHP_SUB_VER_RELEASE; do
            PRIM_VER=$(echo "$i" | awk -F. '{print $1}')
            SELECTED_PHP_SUB_LAST_VER_RELEASE+=$(jq -r --arg primVersion "$PRIM_VER" --arg version "$i" '.php[$primVersion][$version][]' <<< "$PHP_VERS_INFO")
            SELECTED_PHP_SUB_LAST_VER_RELEASE+=" "
        done

        OPTIONS_DIALOG="" 
        for i in $SELECTED_PHP_SUB_LAST_VER_RELEASE; do
            OPTIONS_DIALOG+="$i PHP-$i OFF "
        done

        SELECTED_PHP_SUB_VERSIONS_RELEASE=$(whiptail --title "Select PHP Versions to Install" --notags --checklist \
        "Select options using Space key and navigate with Arrow keys" 15 50 4 \
        $OPTIONS_DIALOG 3>&1 1>&2 2>&3)

        # Check if user cancelled
        if [ $? -ne 0 ]; then
            echo "Cancelled at step 3."
            return 1
        fi

        SELECTED_PHP_SUB_VERSIONS_RELEASE=$(echo $SELECTED_PHP_SUB_VERSIONS_RELEASE | tr -d '"')

        # Check if user selected at least one option
        if [ -z "$SELECTED_PHP_SUB_VERSIONS_RELEASE" ]; then
            echo "No PHP Versions selected for installation. Please select at least one option."
            whiptail --title "Warning" --msgbox "Please select at least one PHP version to install." 8 45
        else
            echo "Selected PHP Version(s) to Install: $SELECTED_PHP_SUB_VERSIONS_RELEASE"
            break
        fi
    done

    # Return selected PHP versions
    echo $SELECTED_PHP_SUB_VERSIONS_RELEASE
    return 0
}