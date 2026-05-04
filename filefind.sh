#!/bin/bash

# Improved Search Tool

LOG_DIR="searchlogs"
mkdir -p "$LOG_DIR"

echo "========================="
echo "   WELCOME TO SEARCH TOOL"
echo "========================="
echo "1) Search for a file"
echo "2) Search for a folder"
read -rp "Choose an option (1 or 2): " choice

# Ask for base directory (instead of always /)
read -rp "Enter directory to search in (default: /home): " base_dir
base_dir=${base_dir:-/home}

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
output="$LOG_DIR/log-$timestamp.txt"

# Function to count results safely
count_results() {
    [[ -f "$1" ]] && wc -l < "$1" || echo 0
}

if [[ "$choice" == "1" ]]; then
    # FILE SEARCH
    read -rp "Enter the file name (supports wildcards like *.txt): " filename
    echo "Searching for files in $base_dir ..."

    # Use mapfile for safe handling
    mapfile -t filelist < <(find "$base_dir" -type f -iname "$filename" 2>/dev/null)

    if [[ ${#filelist[@]} -eq 0 ]]; then
        echo "No files found."
        exit 1
    fi

    read -rp "Enter text to search inside files (optional): " pattern

    if [[ -z "$pattern" ]]; then
        printf "%s\n" "${filelist[@]}" > "$output"
    else
        echo "Searching inside files..."
        for file in "${filelist[@]}"; do
            grep -H "$pattern" "$file" 2>/dev/null
        done > "$output"
    fi

    count=$(count_results "$output")
    echo "Matches found: $count"
    echo "Saved to: $output"

elif [[ "$choice" == "2" ]]; then
    # FOLDER SEARCH
    read -rp "Enter folder name (supports wildcards): " foldername
    echo "Searching for folders in $base_dir ..."

    mapfile -t folderlist < <(find "$base_dir" -type d -iname "$foldername" 2>/dev/null)

    if [[ ${#folderlist[@]} -eq 0 ]]; then
        echo "No folders found."
        exit 1
    fi

    printf "%s\n" "${folderlist[@]}" > "$output"

    count=$(count_results "$output")
    echo "Folders found: $count"
    echo "Saved to: $output"

else
    echo "Invalid choice."
    exit 1
fi
