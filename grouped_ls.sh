#!/bin/bash

echo "Files in current directory:"
ls

echo -e "\nAnalyzing file types..."

# Store the ls output in a variable
files=$(ls)

# Initialize associative array for counting file types
declare -A file_types

# Process each file to determine its type
for filename in $files; do
    if [[ -f "$filename" ]]; then
        # For regular files, get the extension
        if [[ "$filename" == *.* ]]; then
            extension="${filename##*.}"
            extension="${extension,,}"  # Convert to lowercase
        else
            extension="no_extension"
        fi
        
        # Increment counter for this extension
        ((file_types["$extension"]++))
    elif [[ -d "$filename" ]]; then
        ((file_types["directory"]++))
    elif [[ -L "$filename" ]]; then
        ((file_types["symlink"]++))
    else
        ((file_types["other"]++))
    fi
done

# Print the report
echo -e "\nFile Type Summary Report"
echo "========================="
echo -e "\nCounts by file type:"

# Calculate total files
total=0
for type in "${!file_types[@]}"; do
    printf "%-15s %d\n" "$type:" "${file_types[$type]}"
    ((total+=${file_types[$type]}))
done

echo -e "\nTotal files: $total"
