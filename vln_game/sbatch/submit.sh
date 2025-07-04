#!/bin/bash

# check the available partitions
# sinfo | cat

# check current jobs
# squeue -u $USER | cat

# available accounts
# sacctmgr list associations user=$USER format=account,user,qos | cat

# check the job status
# squeue -j 1234 | cat

sbatch task.slurm 

