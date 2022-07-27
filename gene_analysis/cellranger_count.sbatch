#!/bin/bash

## Script to run cellranger count on single cell fastq files
##
## Example usage:
## sbatch cellranger_count.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=24:00:00
#SBATCH --mem=128GB

# Job name and output
#SBATCH -J cellranger
#SBATCH -o /scratch/Users/%u/data/slurmOut/slurm-%j.out
#SBATCH -e /scratch/Users/%u/data/slurmErr/slurm-%j.err

# increase ulimit to what cellranger recommends
ulimit -n 16000

# echo the new ulimit (for troublehsooting later)
bash -c 'ulimit -a'

# try running cellranger count on one sample
pwd; hostname; date

echo $(date +"[%b %d %H:%M:%S] Starting cellranger count...")

cellranger count \
--include-introns=false \
--expect-cells=10000 \
--id=cellrangerV7_output_nointrons \
--fastqs=fastqs \
--sample=10k_PBMC_3p_nextgem_Chromium_X \
--transcriptome=/scratch/Users/ativ2716/data/IFNAR2_with_isoforms_as_genes/hg38_with_IFNAR2_204And202_isoforms

# cellranger count \
# --id=cellranger_output_unmodified_transcriptome \
# --fastqs=fastqs \
# --sample=10k_PBMC_3p_nextgem_Chromium_X \
# --transcriptome=/Shares/CL_Shared/db/genomes/hg38/index/CellRanger/refdata-gex-GRCh38-2020-A \
# --expect-cells=10000

echo $(date +"[%b %d %H:%M:%S] Done!")
