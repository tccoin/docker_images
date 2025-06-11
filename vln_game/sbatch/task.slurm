#!/bin/bash
#SBATCH --partition=mcity_project
#SBATCH --gres=gpu:1             # Request 1 GPU
#SBATCH --time=00:01:00
#SBATCH --job-name=sg_vln
#SBATCH --output=sg_vln_%j.out   # Added job ID to output file name
#SBATCH --error=sg_vln_%j.err    # Added separate error file
#SBATCH --account=mcity_project  # Correct account for this partition
#SBATCH --cpus-per-task=4        # Allocate 4 CPUs per GPU
#SBATCH --mem=16G                # Allocate 16GB memory

# Set environment variables
export SINGULARITY_BIND="/home,/tmp,/var,/etc"

# Path to your Singularity image
SIF_PATH=/path/to/your_container.sif

# Path to your Python script inside the container
PY_SCRIPT=/path/to/your_script.py

# Print job information
echo "Job started at: $(date)"
echo "Running on node: $(hostname)"
echo "Allocated GPUs: $(nvidia-smi -L)"

# Run the Python script inside the Singularity container
# singularity exec --nv $SIF_PATH python $PY_SCRIPT

sleep 10

echo "Job finished at: $(date)"