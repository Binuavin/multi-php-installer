#!/bin/bash

source ./app/php_version_to_json.sh

# Function to Get PHP versions from https://www.php.net/
get_and_save_php_json() {
    local available_versions=$(curl -s https://www.php.net/releases/index.php | grep -oP 'PHP \K\d+\.\d+\.\d+' | sort -urV | tr '\n' ' ')
    save_php_versions_to_json_file $available_versions
}

downl_php_versions_info() {
    if [ -f php_versions.json ]; then 
        # Check for last checked date 
        php_version_date=$(date -d $(cat php_versions.json | jq -r '.lastChecked') +"%s")
        three_months_ago=$(date -d "3 months ago" +%s)

        if [ $php_version_date -lt $three_months_ago ]; then
            echo "Local PHP Versions File Expired.."
            echo "Getting fresh data.."
            # Get Fresh PHP Versions data
            get_and_save_php_json
        fi
        return 0
    else
        echo "PHP Versions JSON file missing.."
        echo "Creating php_versions.json file.."
        get_and_save_php_json
        return 0
    fi
}