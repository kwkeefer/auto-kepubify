#!/bin/bash

INPUT_DIR="/input"
REMOTE_DIR="remote:/$REMOTE_DIRECTORY"

echo "Monitoring files in $INPUT_DIR directory"
inotifywait -m -r -e close_write "$INPUT_DIR" |
while read path action file; do
    echo "The file '$file' appeared in directory '$path' via '$action'"
    
    # Get the relative path from INPUT_DIR
    relative_path=${path#$INPUT_DIR/}
    
    # Construct the full remote path
    remote_path="$REMOTE_DIR/$relative_path"
    
    # Sync only the specific file to the remote path
    rclone copy "$path$file" "$remote_path" --progress
    
    sleep 5 
    
    # Remove the file after it has been copied
    rm "$path$file"
    # remove empty directories
    find $INPUT_DIR -type d -empty -delete
    
    echo "Processed and removed: $path$file"
done