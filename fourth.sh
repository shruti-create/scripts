#!/bin/bash

# FILE FOR RUNNING FIRST GAUSSIAN
# Assumes: in run folder, you have an inputs folder with individual folders per input
# Assumes: in run folder, you have the sbatch files: sbatch-gaussian-[phi].sh in progress-files folder (runs by phi value)
# Goal: runs gaussian on all new inputs

ssh shbhamidipati@login.expanse.sdsc.edu << EOF
source myenv/bin/activate
cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run

sbatch_dir="./progress-files"

# all 0 5 10 15 20 25 30 40 50 60
numbers=(30)

for num in "\${numbers[@]}"; do
    sbatch_file="\$sbatch_dir/sbatch-gaussian-\${num}.sh"
    
    echo "Submitting \$sbatch_file..."
    job_id=\$(sbatch "\$sbatch_file" | awk '{print \$4}')
    echo "Submitted job ID: \$job_id"
    
    echo "Waiting for job \$job_id to complete..."
    while squeue | grep -q "\$job_id"; do
        sleep 10  # Check every 10 seconds
    done
    echo "Job \$job_id completed."
done

EOF

