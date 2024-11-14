#!/bin/bash

echo "Monitoring files in /input directory"
inotifywait -m -r -e close_write /input |
while read path action file; do
    echo "The file '$file' appeared in directory '$path' via '$action'"
    
    # Get the relative path from /input
    relative_path=${path#/input/}
    
    # Create the output directory structure if it doesn't exist
    mkdir -p "/output/$relative_path"
    
    # Run kepubify with the correct output path
    kepubify "$path$file" -o "/output/$relative_path"

    # If COPY_ALL is set to true, copy the original file if it's not already in the output directory
    if [ "$COPY_ALL" = "true" ]; then
        if [ ! -f "/output/$relative_path$file" ]; then
            cp "$path$file" "/output/$relative_path$file"
        fi
    fi

done