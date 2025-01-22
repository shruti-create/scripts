#!/bin/bash

# FILE FOR RUNNING FIRST GAUSSIAN
# Assumes: in run folder, you have an inputs folder with individual folders per input
# Assumes: in run folder, you have the sbatch file: sbatch-gaussian-2.sh in progress-files folder
# Goal: copy sbatch-gaussian-2.sh to each individual folder and run it, ensuring only 2 jobs run at a time
# CHANGE THIS FILE TO BE LIKE SECOND.SH --> NEED ONE FILE TO RUN ON ALL AND CD INTO DIRECTORY 

ssh shbhamidipati@login.expanse.sdsc.edu << EOF
source myenv/bin/activate
cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run

# path to the sbatch-gaussian-2.sh file
sbatch_file="./progress-files/sbatch-gaussian-2.sh"

# function to check running jobs and wait if needed
function wait_for_available_slots() {
    while true; do
        # count the number of running jobs for the user
        running_jobs=\$(squeue -u shbhamidipati --noheader | awk '\$5 == "R" {count++} END {print count+0}')

        # if running jobs are less than 2, break the loop and continue
        if [[ \$running_jobs -lt 1 ]]; then
            break
        fi

        # wait for 30 seconds before checking again
        sleep 30
    done
}

for dir in ./inputs/*/; do
    if [[ -d "\$dir" ]]; then
        cp "\$sbatch_file" "\$dir"

        wait_for_available_slots

        (cd "\$dir" && sbatch sbatch-gaussian-2.sh)
    fi
done

EOF
