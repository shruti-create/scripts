#!/bin/bash

# FILE FOR PROCESSING LOG FILES w/AICD
# Assumes: in "run" folder, there is an "inputs" folder with individual subdirectories containing both .com and .log files

# SSH into remote server
ssh shbhamidipati@login.expanse.sdsc.edu << 'EOF'
source myenv/bin/activate
cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run

for dir in ./inputs/*/; do
    

    log_file=$(find "$dir" -maxdepth 1 -name "*.log" | head -n 1)

    if [[ -f "$log_file" ]]; then
        cd "$dir"
        echo "$dir"
        # fix log file directory
        log_filename=$(basename "$log_file")
        /home/rramji/codes/AICD-3.0.4/AICD -c -m 3 -s -rot 90 0 90 -b -1 0 0 -runpov "$log_filename" -maxarrowlength 1.5 -l 0.025
        cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run
    else
        echo "No .log file found in $dir"
    fi

done

EOF
