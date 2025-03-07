#!/bin/bash

# FILE FOR RUNNING GAUSSIAN JOBS ON EXPANSE
# Assumes: in the run folder, there is a progress-files folder with sbatch-gaussian-[phi].sh scripts
# Goal: Runs Gaussian for each phi (0-50) and each theta batch (1-4)

ssh shbhamidipati@login.expanse.sdsc.edu << EOF
source myenv/bin/activate
#cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run

sbatch_dir="/expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run/progress-files"

# Iterate over all Phi values (0 to 50)
for ((phi= 1;phi <= 1;phi++)); do
    sbatch_file="\$sbatch_dir/sbatch-gaussian-\$phi.sh"

    # Check if the sbatch file exists before submitting
    if [[ -f "\$sbatch_file" ]]; then
        echo "Found \$sbatch_file, submitting jobs..."

        # Submit jobs for each theta batch (1 to 4)
        for batch in {1..4}; do
            echo "Submitting \$sbatch_file with argument \$batch..."
            job_id=\$(sbatch "\$sbatch_file" "\$batch" | awk '{print \$4}')
            echo "Submitted job ID: \$job_id"
            
            # Wait until the job is completed before submitting the next
            echo "Waiting for job \$job_id to complete..."
            while squeue | grep -q "\$job_id"; do
                sleep 10  # Check every 10 seconds
            done
            echo "Job \$job_id completed."
        done
    else
        echo "Skipping: \$sbatch_file does not exist."
    fi
done

EOF
