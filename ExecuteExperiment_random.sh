#!/bin/bash
# --------------------------------------------------------------
### PART 1: Requests resources to run your job.
# --------------------------------------------------------------
### Required. Set the job name
# SBATCH --job-name=jinyeop_parfor


### Optional. Set the output filename.
### SLURM reads %x as the job name and %j as the job ID

#SBATCH --output=LOG/%x-%j.out
#SBATCH --error=LOG/%x-%j.err

### REQUIRED. Specify the PI group for this job
# SBATCH --account=manager

### Optional. Specify email address to use for notification
# SBATCH --mail-user=yeopjin@mit.edu

### REQUIRED. Set the partition for your job.
# SBATCH --partition=standard

#SBATCH -N 1
#SBATCH -c 2
#SBATCH --mem=3G
#SBATCH --time=400:00:00
#SBATCH --array=0-159

# --------------------------------------------------------------
### PART 2: Executes bash commands to run your job
# --------------------------------------------------------------
### SLURM Inherits your environment. cd $SLURM_SUBMIT_DIR not needed
pwd; hostname; date
echo "jobID: $SLURM_ARRAY_TASK_ID"
echo "CPUs per task: $SLURM_CPUS_PER_TASK"
### Load required modules/libraries if needed
module load R/2020a
### This was recommended by MATLAb through technical support
ulimit -u 63536 
cd $PWD

matlab -nodisplay -nosplash -r "ExperimentSession_random_0624($SLURM_ARRAY_TASK_ID,160)"


### 2> LOG/out_test.txt

~