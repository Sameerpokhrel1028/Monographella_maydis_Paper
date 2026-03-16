

module load RepeatModeler
module load RepeatMasker
module load BioPerl

GENOME="Mmaydis_genome_filtered_contig1to88.fasta"

BuildDatabase -name Mmaydis_db $GENOME

RepeatModeler -database Mmaydis_db -threads 64

RepeatMasker -pa 64 -gff -lib RM_*/consensi.fa.classified $GENOME
