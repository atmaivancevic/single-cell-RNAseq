#!/bin/bash

## Script to run cellranger count on single cell fastq files
##
## Example usage:
## inDir=fastq sbatch --array 0-9 cellranger_count.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=24:00:00
#SBATCH --mem=128GB

# Job name and output
#SBATCH -J fastqc
#SBATCH -o /scratch/Users/%u/data/slurmOut/slurm-%A_%a.out
#SBATCH -e /scratch/Users/%u/data/slurmErr/slurm-%A_%a.err

# increase ulimit to what cellranger recommends
ulimit -n 16000

# echo the new ulimit (for troublehsooting later)
bash -c 'ulimit -a'

# define query files
queries=($(ls $inDir/*.fastq.gz | xargs -n 1 basename | cut -d "_" -f 1,2,3,4,5,6,7 | sort | uniq))

# try running cellranger count on one sample
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Starting cellranger counts...")

cellranger count \
--id=sample_"${queries[$SLURM_ARRAY_TASK_ID]}" \
--fastqs=${inDir} \
--sample=${queries[$SLURM_ARRAY_TASK_ID]} \
--transcriptome=/Shares/CL_Shared/db/genomes/hg38/index/CellRanger/refdata-gex-GRCh38-2020-A

echo $(date +"[%b %d %H:%M:%S] Done!")
