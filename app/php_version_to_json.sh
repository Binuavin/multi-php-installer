#!/bin/bash

# Function to add quotes around a string
quote() {
    printf '"%s"' "$1"
}

save_php_versions_to_json_file() {
    # Process the input data
    versions="$@"
    last_check_date="$(date +%Y-%m-%d)"
    output=$(echo "$versions" | awk '
    BEGIN {
        print "{"
        print "    \"lastChecked\": \"'$last_check_date'\","

        print "    \"php\": {"
    }

    function quote(str) {
        gsub(/"/, "\\\"", str)
        return "\"" str "\""
    }

    {
        for (i=1; i<=NF; i++) {
            split($i, parts, ".")
            major = parts[1]
            minor = parts[1] "." parts[2]
            
            if (!(major in versions)) {
                versions[major] = 1
                if (major_count > 0) {
                    print "\n            ]"
                    print "        },"
                }
                printf "        \"%s\": {\n", major
                major_count++
                subversion_count = 0
            }
            
            if (!(minor in subversions)) {
                subversions[minor] = 1
                if (subversion_count > 0) print "\n            ],"
                printf "            \"%s\": [\n", minor
                subversion_count++
            } else {
                printf ",\n"
            }
            printf "                \"%s\"", $i
        }
    }

    END {
        print "\n            ]"
        print "        }"
        print "    }"
        print "}"
    }')

    # to JSON json
    if [ -f "php_versions.json" ]; then
        touch php_versions.json 
    fi
    echo $output > php_versions.json
    # echo $output
}