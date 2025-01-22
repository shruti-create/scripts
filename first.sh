#!/bin/bash

# FILE FOR PREPROCESSING 
# Assumes: in run-test folder, you have an inputs folder with all inputs
# Format: Files all have 0 1 at top, each file is in its own folder in the inputs folder
# first ssh-ing into my account and start the virtual environment 
# open folder where I have all inputs in
# puts each file into its own folder

ssh shbhamidipati@login.expanse.sdsc.edu << 'EOF'
source myenv/bin/activate
cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run

for com_file in ./inputs/*.com; do
    sed -i '0,/^C[[:space:]]\|^[A-Z][[:space:]]\+-\?[0-9]/s//0 1\n&/' "$com_file"
done

for com_file in ./inputs/*.com; do
    base_name=$(basename "$com_file" .com)
    mkdir -p "./inputs/$base_name"
    mv "$com_file" "./inputs/$base_name/"
done

EOF
