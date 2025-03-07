#!/bin/bash
# download pdb files

REMOTE_USER="shbhamidipati"
REMOTE_HOST="expanse"
REMOTE_DIR="/expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run/inputs"
LOCAL_DIR=~/Desktop/pndit

mkdir -p "$LOCAL_DIR"

echo "Connecting to ${REMOTE_HOST} to retrieve file list..."

ssh ${REMOTE_USER}@${REMOTE_HOST} "find ${REMOTE_DIR} -type f -name '*.pdb'" > pdb_list.txt

if [ ! -s pdb_list.txt ]; then
    echo "No PDB files found. Exiting."
    rm pdb_list.txt
    exit 1
fi

echo "File list retrieved. Downloading files..."

while IFS= read -r remote_file; do
    relative_path="${remote_file#${REMOTE_DIR}/}"
    local_file_path="${LOCAL_DIR}/${relative_path}"
    mkdir -p "$(dirname "${local_file_path}")"
    echo "Downloading: $remote_file to $local_file_path"
    scp "${REMOTE_USER}@${REMOTE_HOST}:${remote_file}" "${local_file_path}"
done < pdb_list.txt



echo "Download complete. Files are saved in: $LOCAL_DIR"

