

INDIR="/scratch/sp47126/Akshaya_Seq"
OUTDIR="/scratch/sp47126/Akshaya_Seq/Kmer_Counts"

cd $INDIR

: '
ml Jellyfish

# Kmer count MNG128S_m64284e_230725_101122.subreads.fastq 

jellyfish count -C -m 21 -s 100M -t 10 -o MNG128S.reads.jf MNG128S_m64284e_230725_101122.subreads.fastq 
jellyfish histo -t 50 MNG128S.reads.jf > $OUTDIR/MNG128S.reads.histo


# kmer count MNG133S_m64284e_230725_101122.subreads.fastq


jellyfish count -C -m 21 -s 100M -t 10 -o MNG133S.reads.jf MNG133S_m64284e_230725_101122.subreads.fastq
jellyfish histo -t 50 MNG133S.reads.jf > $OUTDIR/MNG133S.reads.histo


# kmer count MNG137S_m64284e_230725_101122.subreads.fastq

jellyfish count -C -m 21 -s 100M -t 10 -o MNG137S.reads.jf MNG137S_m64284e_230725_101122.subreads.fastq
jellyfish histo -t 50 MNG137S.reads.jf > $OUTDIR/MNG137S.reads.histo

'

ml SAMtools
ml BEDTools
ml canu
ml minimap2
ml miniasm

##
# Input BAM files containing aligned PacBio long reads for each replicate
bam_replicate1="MNG128S_m64284e_230725_101122.subreads.bam"
bam_replicate2="MNG133S_m64284e_230725_101122.subreads.bam"
bam_replicate3="MNG137S_m64284e_230725_101122.subreads.bam"

# Filtered BAM files containing aligned reads with quality > 10 and length > 100 bases for each replicate
filtered_bam_replicate1="filtered_reads_replicate1.bam"
filtered_bam_replicate2="filtered_reads_replicate2.bam"
filtered_bam_replicate3="filtered_reads_replicate3.bam"

# Output directory for assembly results for each replicate
assembly_output_replicate1="genome_assembly_replicate1"
assembly_output_replicate2="genome_assembly_replicate2"
assembly_output_replicate3="genome_assembly_replicate3"

# Perform filtering and assembly for replicate 1
samtools view -b -q 10 "$bam_replicate1" > "$filtered_bam_replicate1"
bedtools bamtofastq -i "$filtered_bam_replicate1" -fq filtered_reads_replicate1.fastq
canu -p assembly_replicate1 -d "$assembly_output_replicate1" genomeSize=50m -pacbio-raw filtered_reads_replicate1.fastq useGrid=true gridOptions="--partition=batch --cpus-per-task=32 --ntasks=1 --time=24:00:00"


# Perform filtering and assembly for replicate 2
samtools view -b -q 10 "$bam_replicate2" > "$filtered_bam_replicate2"
bedtools bamtofastq -i "$filtered_bam_replicate2" -fq filtered_reads_replicate2.fastq

# Run Canu assembly for replicate 2
canu -p assembly_replicate2 -d "$assembly_output_replicate2" genomeSize=50m -pacbio-raw filtered_reads_replicate2.fastq useGrid=true gridOptions="--partition=batch --cpus-per-task=32 --ntasks=1 --time=10:00:00"


# Perform filtering and assembly for replicate 3
samtools view -b -q 10 "$bam_replicate3" > "$filtered_bam_replicate3"
bedtools bamtofastq -i "$filtered_bam_replicate3" -fq filtered_reads_replicate3.fastq
canu -p assembly_replicate3 -d "$assembly_output_replicate3" genomeSize=100m -pacbio-raw filtered_reads_replicate3.fastq useGrid=true gridOptions="--partition=batch --cpus-per-task=32 --ntasks=1 --time=24:00:00"


# MAking a consensus genome assembly..
ml minimap2
ml miniasm
ml Racon
ml SAMtools
ml BCFtools

# Run minimap2 to generate SAM file
minimap2 -ax asm20 -t 32 assembly_replicate3.contigs.fasta assembly_replicate2.contigs.fasta assembly_replicate1.contigs.fasta > alignments.sam

# Step 1: Convert SAM to BAM
samtools view -bS alignments.sam > alignments.bam

# Step 2: Sort BAM file
samtools sort alignments.bam -o alignments.sorted.bam

# Step 3: Index sorted BAM file
samtools index alignments.sorted.bam

# Step 4: Generate VCF file containing variants
bcftools mpileup -f assembly_replicate3.contigs.fasta -Ou alignments.sorted.bam | bcftools call -mv -Ov -o variants.vcf

# Step 5: Generate consensus sequence from VCF file
bgzip -c variants.vcf > variants.vcf.gz
tabix -p vcf variants.vcf.gz
bcftools consensus -f assembly_replicate3.contigs.fasta variants.vcf.gz -o test_consensus.fasta

