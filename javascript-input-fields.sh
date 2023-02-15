#!/bin/bash

# Set the default URL to search
url="http://example.com"

# Set the default search criteria
input_type="text|password"
js_event="onchange|onkeyup"

# Set default output format
output_format="text"

# Set default output file name
output_file=""

# Set default quiet mode
quiet_mode="false"

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u|--url) url="$2"; shift ;;
        -t|--type) input_type="$2"; shift ;;
        -e|--event) js_event="$2"; shift ;;
        -f|--format) output_format="$2"; shift ;;
        -o|--output) output_file="$2"; shift ;;
        -q|--quiet) quiet_mode="true"; ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Retrieve the webpage and search for input fields
search_results=$(curl -s "$url" | grep -Eo '<input[^>]* (type="'$input_type'") [^>]*('$js_event')="[^"]*"[^>]*>')

# Output the results
if [[ "$quiet_mode" = "true" ]]; then
    if [[ -n "$search_results" ]]; then
        exit 0
    else
        exit 1
    fi
elif [[ "$output_format" = "json" ]]; then
    output=$(echo "$search_results" | jq -R 'split("\n")[:-1] | map(split("\"") | {name: .[1], event: .[3], value: .[5]})')
    if [[ -n "$output_file" ]]; then
        echo "$output" > "$output_file"
    else
        echo "$output"
    fi
elif [[ "$output_format" = "csv" ]]; then
    output=$(echo "$search_results" | sed 's/\s\+/ /g' | tr -d '\n' | sed 's/<input/\n<input/g' | grep -Eo '<input[^>]*>')
    output=$(echo "$output" | awk -vORS=, -F'"' '{ print $2, $4, $6 }' | sed 's/,$/\n/')
    if [[ -n "$output_file" ]]; then
        echo "$output" > "$output_file"
    else
        echo "$output"
    fi
else
    echo "$search_results"
fi
