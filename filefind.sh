#!/bin/bash

# My Search Tool
mkdir -p searchlogs

echo "========================="
echo "  WELCOME TO MY SEARCH TOOL      "
echo "========================="
echo "1) Search for a file"
echo "2) Search for a folder"
read -p "Choose an option (1 or 2): " choice

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
output="searchlogs/log-$timestamp.txt"

if [[ "$choice" == "1" ]]; then
    # FILE SEARCH
    read -p "Enter the file name to search: " filename
    echo "Searching for files named '$filename'..."
    
    filelist=$(find / -type f -name "$filename" 2>/dev/null)
    if [[ $(echo "$filelist" | wc -w) -eq 0 ]]; then
        echo "No files found. Exiting..."
        exit 1
    fi
    
    read -p "Enter the text matching the pattern (optional, press Enter to skip): " pattern
    if [[ -z "$pattern" ]]; then
        echo "$filelist" > "$output"
    else
        grep -H "$pattern" $filelist > "$output" 2>/dev/null
    fi
    
    count=$(wc -l < "$output")
    echo "Number of matches found: $count"

elif [[ "$choice" == "2" ]]; then
    # FOLDER SEARCH
    read -p "Enter the folder name to search: " foldername
    echo "Searching for folders named '$foldername'..."
    
    folderlist=$(find / -type d -name "$foldername" 2>/dev/null)
    if [[ $(echo "$folderlist" | wc -w) -eq 0 ]]; then
        echo "No folders found. Exiting..."
        exit 1
    fi

    echo "Folders found:"
    echo "$folderlist"

    read -p "Do you want to search for files inside these folders? (y/n): " ans
    if [[ "$ans" == "y" ]]; then
        read -p "Enter the file name or pattern to search inside these folders: " filepattern
        # Search inside all found folders
        find $folderlist -type f -name "$filepattern" 2>/dev/null > "$output"
        count=$(wc -l < "$output")
        echo "Number of files found inside folders: $count"
    else
        echo "$folderlist" > "$output"
    fi
else
    echo "Invalid choice. Exiting..."
    exit 1
fi

# Display log
echo -e "\nLog Output:"
cat "$output"
echo -e "\nResults saved in $output"

