#!/bin/bash

# FILE FOR PREPARING INPUTS FOR SECOND GAUSSIAN
# Assumes: in run-test folder, you have an inputs folder with individual folders per input with both com and log files 
# Assumes: Python script in progress-files folder
# Goal: run python script on every log file and then add the pi-MOs found to the end of the .com file

ssh shbhamidipati@login.expanse.sdsc.edu << 'EOF'
source myenv/bin/activate
cd /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run

for dir in ./inputs/*/; do
    log_file=$(find "$dir" -maxdepth 1 -name "*.log")
    if [[ -f "$log_file" ]]; then
        numbers=$(python3 ./progress-files/identify_pi_MOs.py --file "$log_file" --num_orbitals 6)
        com_file=$(find "$dir" -maxdepth 1 -name "*.com")
        if [[ -f "$com_file" ]]; then
            # Replace the specific line in the .com file
            sed -i 's/^#HF\/6-31G\* scf=tight pop=full/#HF\/6-31G\* scf=tight nmr=csgt iop(10\/93=2)/' "$com_file"
            
            # Append additional information to the .com file
            sed -i '${s/$/test.txt/}' "$com_file"  # Append "test.txt" to the last line            
            echo "" >> "$com_file"
            echo "$numbers" >> "$com_file"
            echo "" >> "$com_file"
            echo "" >> "$com_file"
        else
            echo "No .com file found in $dir"
        fi
        rm "$log_file"
    else
        echo "No .log file found in $dir"
    fi
done

EOF
