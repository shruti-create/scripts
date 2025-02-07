### Shruti's notes - 

## Process to complete calculation workflow: 


1. Make sure this is the current organization of files: 

    ```
    /expanse/lustre/projects/csd799/rramji/shruti-AICD-demo/run
    ----/progress-files
    --------sbatch-gaussian.sh (runs on all items in inputs)
    --------sbatch-gaussian-[phi].sh (there should be one per phi value in this folder)
    --------identify_pi_MOs.py
    ----/inputs
    --------ALL INPUT FILES

    ```

2. Run first.sh -- to pre-process the input files to work with gaussian 
3. Run second.sh -- to run gaussian
4. Run third.sh -- to calculate Pi-MOs for each molecule and add them to the bottom of the text file. Also, modifies the input for our next gaussian simulation
5. Run fourth.sh -- to run gaussian for the AICD inputs
6. Run fifth.sh -- to run AICD on the gaussian outputs
7. Run sixth.sh -- to download the pdb files
8. Run seventh.sh -- to download the inc files