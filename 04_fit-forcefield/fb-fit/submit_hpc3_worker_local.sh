#!/bin/bash

# This worker script sets up and launches multiple parallel tasks on a SLURM cluster to work in conjunction with the master script for ff optimization
echo "SLURM_JOB_NAME: $SLURM_JOB_NAME"

# Reads the host and port details from host and optimize.in. These are necesary for work_queue_worker process to communicate with the master
host=$(sed 1q host)
port=$(awk '/port/ {print $NF}' optimize.in)

# Debugging: Print host and port
echo "Host: $host"
echo "Port: $port"


USERNAME=$(whoami)
export SLURM_TMPDIR=/scratch/alpine/juho8819/LipidsFFF/tmp
export MYTMPDIR="${SLURM_TMPDIR}/${USERNAME}"
export TMPDIR=$SLURM_TMPDIR/

# Ensure the temporary directory exists
mkdir -p ${MYTMPDIR} || { echo "Failed to create MYTMPDIR"; exit 1; }

# Dynamically calcualtes the number of workers and assigns resources for each worker job
worker_num=$(squeue -u ${USERNAME} | grep wq -c)
ncpus=10

echo submitting worker $worker_num with $ncpus cpus on $host:$port
conda_env="sep-2024-env"

cmd=$(mktemp)
cat << EOF > $cmd
#!/usr/bin/env bash
#SBATCH -J wq-$port
#SBATCH -p amilan
#SBATCH -t 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=${ncpus}
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --array=1-500%50
#SBATCH --account ucb500_asc1
# SBATCH --export ALL
#SBATCH -o worker-logs/worker-${worker_num}-%a.log

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

ml anaconda
source $HOME/.bashrc

mkdir -p ${MYTMPDIR}
cd $MYTMPDIR

conda activate $conda_env

for i in \$(seq  \$SLURM_NTASKS ); do
        echo $i
        work_queue_worker --cores 1 -s ${MYTMPDIR} \
                          --disk-threshold=0.002 --disk=3000 \
                          --memory-threshold=1000 -t 3600 -b 20 \
                          --memory=1000 $host:$port &
done
wait
EOF

# Submit worker job
sbatch $@ $cmd

# Clean up temporary file
rm $cmd
