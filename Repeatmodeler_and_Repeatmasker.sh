sp47126@ss-sub1 FINAL_RESULTS_Only$ more  Repeatmodeler_repeatmasker.sh
#!/bin/bash
#SBATCH --job-name=repeat_mmaydis
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=80gb
#SBATCH --time=8:00:00
#SBATCH --output=log.repeat.%j

module load RepeatModeler/2.0.4-foss-2022a
module load RepeatMasker/4.2.3-foss-2023a
module load BioPerl/1.7.8-GCCcore-14.2.0

GENOME="Mmaydis_genome_filtered_contig1to88.fasta"

BuildDatabase -name Mmaydis_db $GENOME

RepeatModeler -database Mmaydis_db -threads 64

RepeatMasker -pa 64 -gff -lib RM_*/consensi.fa.classified $GENOME