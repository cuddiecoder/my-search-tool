#!/bin/bash

# =========================
#   SMART SEARCH TOOL v2
# =========================

LOG_DIR="$HOME/searchlogs"
mkdir -p "$LOG_DIR"

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"

echo -e "${GREEN}=========================${NC}"
echo -e "${GREEN}   WELCOME TO SEARCH TOOL ${NC}"
echo -e "${GREEN}=========================${NC}"

echo "1) Search for a file"
echo "2) Search for a folder"
read -rp "Choose an option (1 or 2): " choice

# safer default (root search like real tools)
read -rp "Enter directory to search in (default: /): " base_dir
base_dir=${base_dir:-/}

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
output="$LOG_DIR/log-$timestamp.txt"

echo -e "${YELLOW}Searching in: $base_dir${NC}"
echo ""

# =========================
# FILE SEARCH
# =========================
if [[ "$choice" == "1" ]]; then

    read -rp "Enter file name (supports wildcards like *.txt): " filename

    mapfile -t filelist < <(find "$base_dir" -type f -iname "$filename" 2>/dev/null)

    if [[ ${#filelist[@]} -eq 0 ]]; then
        echo -e "${RED}No files found.${NC}"
        exit 1
    fi

    echo -e "${GREEN}=== RESULTS FOUND ===${NC}"
    printf "%s\n" "${filelist[@]}"
    echo -e "${GREEN}=====================${NC}"
    echo "Total: ${#filelist[@]}"
    echo ""

    read -rp "Search inside these files? (enter keyword or press Enter to skip): " pattern

    if [[ -z "$pattern" ]]; then

        {
            echo "Search time: $(date)"
            echo "Base directory: $base_dir"
            echo "File search: $filename"
            echo ""
            printf "%s\n" "${filelist[@]}"
            echo ""
            echo "Total results: ${#filelist[@]}"
        } > "$output"

    else

        matches=()

        for file in "${filelist[@]}"; do
            if grep -qi "$pattern" "$file" 2>/dev/null; then
                matches+=("$file")
            fi
        done

        if [[ ${#matches[@]} -eq 0 ]]; then
            echo -e "${RED}No matches found inside files.${NC}"
            exit 1
        fi

        echo -e "${GREEN}=== FILES CONTAINING MATCH ===${NC}"
        printf "%s\n" "${matches[@]}"
        echo -e "${GREEN}==============================${NC}"
        echo "Total matches: ${#matches[@]}"
        echo ""

        {
            echo "Search time: $(date)"
            echo "Base directory: $base_dir"
            echo "Pattern searched: $pattern"
            echo ""
            printf "%s\n" "${matches[@]}"
            echo ""
            echo "Total matches: ${#matches[@]}"
        } > "$output"
    fi

# =========================
# FOLDER SEARCH
# =========================
elif [[ "$choice" == "2" ]]; then

    read -rp "Enter folder name (supports wildcards): " foldername

    mapfile -t folderlist < <(find "$base_dir" -type d -iname "$foldername" 2>/dev/null)

    if [[ ${#folderlist[@]} -eq 0 ]]; then
        echo -e "${RED}No folders found.${NC}"
        exit 1
    fi

    echo -e "${GREEN}=== FOLDERS FOUND ===${NC}"
    printf "%s\n" "${folderlist[@]}"
    echo -e "${GREEN}=====================${NC}"
    echo "Total: ${#folderlist[@]}"

    {
        echo "Search time: $(date)"
        echo "Base directory: $base_dir"
        echo "Folder search: $foldername"
        echo ""
        printf "%s\n" "${folderlist[@]}"
        echo ""
        echo "Total results: ${#folderlist[@]}"
    } > "$output"

else
    echo -e "${RED}Invalid option${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Saved log to:${NC} $output"
