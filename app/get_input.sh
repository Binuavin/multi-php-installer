#!/bin/bash

get_yn_input() {

    local prompt="$1"
    local response

    while true; do
        read -p "$prompt (y/n)" response
        
        # Convert the user response to lowercase
        response=${response,,}
        
        # If input is empty, treat it as "yes"
        if [ -z "$response" ]; then
            response="y"
        fi

        case $response in 
            y|yes ) 
                echo 0;
                break
                ;;
            n|no ) 
                echo 1;
                break
                ;;
            * ) 
                echo -e "Invalid response. Please try again.\n" >&2
                ;;
        esac
    done
}