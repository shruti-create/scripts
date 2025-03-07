#!/bin/bash
#SBATCH --job-name=ptb7-pi-gaussian    # Job name
#SBATCH --partition=debug              # Partition name
#SBATCH --nodes=1                      # Number of nodes
#SBATCH --ntasks-per-node=64           # Number of tasks (MPI processes)
#SBATCH --time=00:30:00                # Run time (hh:mm:ss)
#SBATCH --account=csd799

module purge
module load cpu/0.15.4
module load gaussian/16.C.01

root_dir="/expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run/inputs"

target_phi="Phi_0"

for dir in "$root_dir"/*/; do
    if [[ -d "$dir" ]]; then
        echo "Processing directory: $dir"

        cd "$dir" || { echo "Failed to enter directory: $dir"; exit 1; }

        for file in ./*"${target_phi}"*.com; do
            if [[ -f "$file" ]]; then
                echo "Running Gaussian on $file"
                g16 "$file"
            else
                echo "No .com files with Phi value $target_phi found in $dir"
            fi
        done

        cd - > /dev/null || exit
    fi
done
