#!/bin/bash

process_csv() {
    python3 "mysql create table.py" "$1"
}

# Check if arguments are provided
if [ $# -gt 0 ]; then
    # Loop through provided arguments
    for arg in "$@"; do
        # Check if argument is a file
        if [ -f "$arg" ]; then
            # Process the file if it's a CSV
            if [[ "$arg" == *.csv ]]; then
                process_csv "$arg"
            else
                echo "Skipping non-CSV file: $arg"
            fi
        else
            echo "File not found: $arg"
        fi
    done
else
    # If no arguments provided, loop through CSV files in current directory
    for file in *.csv; do
        process_csv "$file"
    done
fi

