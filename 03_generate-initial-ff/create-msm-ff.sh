#!/bin/bash
#SBATCH -J msm
#SBATCH -p amilan
#SBATCH -t 1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --account ucb-general
#SBATCH --export ALL
#SBATCH -o msm.out
#SBATCH -e msm.err

date
hostname

source ~/.bashrc
ml anaconda
conda activate sep-2024-env 

python create-msm-ff.py                                                                                     \
    --initial-force-field       "../01_generate-forcefield/output/initial-force-field.offxml"  \
    --optimization-dataset      "../02_curate-data/output/optimization-training-set.json"                   \
    --hessian-datasets          "OpenFF Sulfur Hessian Training Coverage Supplement v1.0" \
    --frozen-angle-file         "linear-angles.json" \
    --working-directory         "working-directory"                                                         \
    --output                    "output/initial-force-field-msm.offxml" \
    --verbose

date
