#!/bin/bash

## Example usage:
## inDir=C152 sbatch --array 0-9 gzip.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=24:00:00
#SBATCH --mem=128GB

# Job name and output
#SBATCH -J gzip
#SBATCH -o /scratch/Users/%u/data/slurmOut/slurm-%j.out
#SBATCH -e /scratch/Users/%u/data/slurmErr/slurm-%j.err

# set query files
queries=($(ls $inDir/*.fastq | xargs -n 1 basename))

# run the thing
pwd; hostname; date

# keep original files, for now
cd $inDir
gzip -c ${queries[$SLURM_ARRAY_TASK_ID]} > ${queries[$SLURM_ARRAY_TASK_ID]}.gz
cd ..
# only delete original uncompressed files after all files have finished gzipping

echo $(date +"[%b %d %H:%M:%S] Done!")
