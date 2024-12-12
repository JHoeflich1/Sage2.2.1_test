#!/bin/bash
#SBATCH -J download_and_filter_opt
#SBATCH -p amilan
#SBATCH -t 4-00:00:00
#SBATCH --qos=long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --account=ucb500_asc1 
#SBATCH --export ALL
#SBATCH -o download_and_filter_opt.out
#SBATCH -e download_and_filter_opt.err

date
hostname

source ~/.bashrc
ml anaconda
conda activate sep-2024-env

python curate-dataset.py download-opt                                           \
    --core-opt-dataset      "OpenFF Gen 2 Opt Set 1 Roche"                      \
    --core-opt-dataset      "OpenFF Gen 2 Opt Set 2 Coverage"                   \
    --core-opt-dataset      "OpenFF Gen 2 Opt Set 3 Pfizer Discrepancy"         \
    --core-opt-dataset      "OpenFF Gen 2 Opt Set 4 eMolecules Discrepancy"     \
    --core-opt-dataset      "OpenFF Gen 2 Opt Set 5 Bayer"                      \
    --core-opt-dataset      "OpenFF Optimization Set 1"                         \
    --core-opt-dataset      "SMIRNOFF Coverage Set 1"                           \
    --core-opt-dataset      "OpenFF Aniline Para Opt v1.0"                      \
    --core-opt-dataset      "OpenFF Sulfur Optimization Training Coverage Supplement v1.0" \
    --iodine-opt-dataset    "OpenFF Gen2 Optimization Dataset Protomers v1.0"   \
    --iodine-opt-dataset    "OpenFF Iodine Chemistry Optimization Dataset v1.0" \
    --opt-records-to-remove "opt_records_to_remove.dat"                         \
    --max-opt-conformers    12                                                  \
    --output                "output/optimization-training-set.json"             \
    --initial-forcefield    "../01_generate-forcefield/output/initial-force-field.offxml" \
    --output-parameter-smirks  "output/training-valence-smirks.json"            \
    --verbose


date
