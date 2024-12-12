#!/bin/bash
#SBATCH -J fb_input
#SBATCH -p amilan
#SBATCH -t 1-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --account ucb-general
#SBATCH --export ALL
#SBATCH -o fb_input.out-%A
#SBATCH -e fb_input.err-%A

# creates output/schemas/optimizations folder

date
hostname

source ~/.bashrc
ml anaconda
conda activate sep-2024-env 

python create-fb-inputs.py                                                                          \
    --tag                       "fb-fit"                                                            \
    --optimization-dataset      "../02_curate-data/output/optimization-training-set.json"           \
    --torsion-dataset           "../02_curate-data/output/torsion-training-set.json"                \
    --forcefield                "../03_generate-initial-ff/output/initial-force-field-msm.offxml"   \
    --valence-to-optimize       "../02_curate-data/output/training-valence-smirks.json"             \
    --torsions-to-optimize      "../02_curate-data/output/training-torsion-smirks.json"             \
    --frozen-angle-file         "../03_generate-initial-ff/linear-angles.json"                               \
    --smiles-to-exclude         "smiles-to-exclude.dat"                                             \
    --smarts-to-exclude         "smarts-to-exclude.dat"                                             \
    --max-iterations            100                                                                 \
    --port                      55481                                                               \
    --output-directory          "output"                                                            \
    --verbose

