#!/bin/bash

#This script helps find any file of your choice

#Prompt user to enter  the name of the file
read -p "Enter the name of the file you want to search: " filename

echo  "Searching for files named '$filename'..."


#search  for the file first  

filelist=$(find / -type f -name "$filename" 2>/dev/null)

# If no files found
if [[ $(echo "$filelist" | wc -w) -eq 0 ]]; then
    echo " No files found with the name '$filename'. Exiting..."
    exit 1
fi


#Prompt the user to enter the pattern to be searched inside the found file match

read  -p "Enter the text matching the pattern: " pattern

echo  "Running search....."


#create a timestamp for each search log

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

#Create a folder for storing the logs if it doesnt exist

mkdir -p searchlogs


output="searchlogs/log-$timestamp.txt"

#Perform grep search on the file

grep -H "$pattern" "$filelist" > "$output" 2>/dev/null

# Count the number of matches found
count=$(grep -c "$pattern" "$filelist" 2>/dev/null)
echo "Number of matches found: $count"

# Pattern not found?

if [[ ! -s "$output" ]]; then
    echo " Pattern '$pattern' NOT found — log saved but empty."
else
    echo " Search complete! Results saved to $output"
fi

# Show log
echo -e "\n Log Output:\n"
cat "$output"

