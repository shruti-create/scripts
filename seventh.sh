#!/bin/bash
# download inc files

REMOTE_USER="shbhamidipati"
REMOTE_HOST="expanse"
REMOTE_DIR="/expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run/inputs"
LOCAL_DIR=~/Desktop/pndit

mkdir -p "$LOCAL_DIR"

echo "Connecting to ${REMOTE_HOST} to retrieve folder list..."

ssh ${REMOTE_USER}@${REMOTE_HOST} "find ${REMOTE_DIR} -type d -name '*.d'" > folder_list.txt

if [ ! -s folder_list.txt ]; then
    echo "No matching folders found. Exiting."
    rm folder_list.txt
    exit 1
fi

echo "Folder list retrieved. Searching for files..."

while IFS= read -r remote_folder; do
    echo "Checking folder: $remote_folder"
    
    molecule_name=$(basename "$(dirname "$remote_folder")")
    local_folder="${LOCAL_DIR}/${molecule_name}"
    mkdir -p "$local_folder"
    
    for file in Isoober.inc Molekuel.inc; do
        remote_file="${remote_folder}/${file}"
        
        echo "Downloading: $remote_file to $local_folder"
        
        scp "${REMOTE_USER}@${REMOTE_HOST}:${remote_file}" "$local_folder/" 2>/dev/null || echo "File $file not found in $remote_folder"
    done
done < folder_list.txt

rm folder_list.txt
echo "Download complete. Files are saved in: $LOCAL_DIR"
