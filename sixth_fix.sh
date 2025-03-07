#!/bin/bash
# download one PDB file per folder using a single SSH connection

REMOTE_USER="shbhamidipati"
REMOTE_HOST="login.expanse.sdsc.edu"
REMOTE_DIR="/expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run/inputs"
LOCAL_DIR=~/Desktop/pndit

mkdir -p "$LOCAL_DIR"

echo "Connecting to ${REMOTE_HOST} to find one PDB file per folder..."

# Get one .pdb file per folder on the remote machine
pdb_list=$(ssh ${REMOTE_USER}@${REMOTE_HOST} "
    find ${REMOTE_DIR} -type f -name '*.pdb' | 
    awk -F'/' '{folders[\$0] = \$0} END {for (f in folders) print folders[f]}'"
)

if [ -z "$pdb_list" ]; then
    echo "No PDB files found. Exiting."
    exit 1
fi

echo "File list retrieved. Downloading files..."

# Use rsync to transfer only the selected files
while IFS= read -r remote_file; do
    relative_path="${remote_file#${REMOTE_DIR}/}"
    local_file_path="${LOCAL_DIR}/${relative_path}"
    mkdir -p "$(dirname "${local_file_path}")"
    echo "Downloading: $remote_file to $local_file_path"
    rsync -avz "${REMOTE_USER}@${REMOTE_HOST}:${remote_file}" "${local_file_path}"
done <<< "$pdb_list"

echo "Download complete. Files are saved in: $LOCAL_DIR"
