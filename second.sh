#!/bin/bash

# FILE FOR RUNNING FIRST GAUSSIAN 
# Assumes: in run folder, you have an inputs folder with individual folders per input
# Assumes: in run folder, you have the sbatch file: sbatch-gaussian.sh in progress-files folder
# Goal: run the file in each individual folder with the gaussian file
# first ssh-ing into my account and start the virtual environment 


ssh shbhamidipati@login.expanse.sdsc.edu << 'EOF'
source myenv/bin/activate
cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run/progress-files

sbatch sbatch-gaussian.sh

EOF