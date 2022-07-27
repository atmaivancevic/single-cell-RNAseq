#!/bin/bash

## Example usage:
## outDir=. sraFile=sra_accessions.txt sbatch --array 0-12 sra_download.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=24:00:00
#SBATCH --mem=500GB

# Job name and output
#SBATCH -J sraDownload
#SBATCH -o /scratch/Users/%u/data/slurmOut/slurm-%A_%a.out
#SBATCH -e /scratch/Users/%u/data/slurmErr/slurm-%A_%a.err

# set query files
queries=($(cat $sraFile | grep -v "#" | awk '{print $1}'))

# run the thing
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Downloading sra...")

#note: need to specify --include-technical and --split-files
# in order to download all three files for single cell RNAseq
# also, don't need to module load sra, since the newest version (sra3.0.0) is in my ~/.bash_profile PATH

fasterq-dump -e 8 -O $outDir --include-technical --split-files -v -v \
-t /scratch/Users/ativ2716/data/fasterq-dump-temp \
${queries[$SLURM_ARRAY_TASK_ID]}

echo $(date +"[%b %d %H:%M:%S] Done!")
