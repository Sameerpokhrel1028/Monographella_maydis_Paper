
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


## QUAST

quast datafile -o out_directory



Assembly                    assembly_replicate1.contigs
# contigs (>= 0 bp)         145                        
# contigs (>= 1000 bp)      145                        
# contigs (>= 5000 bp)      87                         
# contigs (>= 10000 bp)     61                         
# contigs (>= 25000 bp)     35                         
# contigs (>= 50000 bp)     34                         
Total length (>= 0 bp)      39683060                   
Total length (>= 1000 bp)   39683060                   
Total length (>= 5000 bp)   39516918                   
Total length (>= 10000 bp)  39346743                   
Total length (>= 25000 bp)  38932774                   
Total length (>= 50000 bp)  38889660                   
# contigs                   145                        
Largest contig              3596942                    
Total length                39683060                   
GC (%)                      54.05                      
N50                         1658755                    
N90                         479639                     
auN                         1929198.8                  
L50                         8                          
L90                         22                         
# N's per 100 kbp           0.00                       


## BUSCO

busco -f -i file -l ascomycota_odb10 -o busco -m genome -c 4

## Busco
	---------------------------------------------------
	|Results from dataset ascomycota_odb10             |
	---------------------------------------------------
	|C:97.6%[S:96.7%,D:0.9%],F:0.6%,M:1.8%,n:1706      |
	|1665	Complete BUSCOs (C)                        |
	|1649	Complete and single-copy BUSCOs (S)        |
	|16	Complete and duplicated BUSCOs (D)         |
	|11	Fragmented BUSCOs (F)                      |
	|30	Missing BUSCOs (M)                         |
	|1706	Total BUSCO groups searched                |

C:97.6%[S:96.7%,D:0.9%],F:0.6%,M:1.8%,n:1706




# Perform filtering and assembly for replicate 2
samtools view -b -q 10 "$bam_replicate2" > "$filtered_bam_replicate2"
bedtools bamtofastq -i "$filtered_bam_replicate2" -fq filtered_reads_replicate2.fastq

# Run Canu assembly for replicate 2
canu -p assembly_replicate2 -d "$assembly_output_replicate2" genomeSize=50m -pacbio-raw filtered_reads_replicate2.fastq useGrid=true gridOptions="--partition=batch --cpus-per-task=32 --ntasks=1 --time=10:00:00"



Assembly                    assembly_replicate2.contigs
# contigs (>= 0 bp)         100                        
# contigs (>= 1000 bp)      100                        
# contigs (>= 5000 bp)      83                         
# contigs (>= 10000 bp)     78                         
# contigs (>= 25000 bp)     53                         
# contigs (>= 50000 bp)     52                         
Total length (>= 0 bp)      43231871                   
Total length (>= 1000 bp)   43231871                   
Total length (>= 5000 bp)   43187394                   
Total length (>= 10000 bp)  43148413                   
Total length (>= 25000 bp)  42736475                   
Total length (>= 50000 bp)  42709093                   
# contigs                   100                        
Largest contig              3671647                    
Total length                43231871                   
GC (%)                      55.89                      
N50                         1461316                    
N90                         401732                     
auN                         1606234.5                  
L50                         10                         
L90                         33                         
# N's per 100 kbp           0.00                       




2024-06-09 21:04:59 INFO:	Results:	C:96.9%[S:96.3%,D:0.6%],F:0.9%,M:2.2%,n:1706	   

2024-06-09 21:06:26 INFO:	

	---------------------------------------------------
	|Results from dataset ascomycota_odb10             |
	---------------------------------------------------
	|C:96.9%[S:96.3%,D:0.6%],F:0.9%,M:2.2%,n:1706      |
	|1653	Complete BUSCOs (C)                        |
	|1643	Complete and single-copy BUSCOs (S)        |
	|10	Complete and duplicated BUSCOs (D)         |
	|16	Fragmented BUSCOs (F)                      |
	|37	Missing BUSCOs (M)                         |
	|1706	Total BUSCO groups searched                |
	---------------------------------------------------




# Perform filtering and assembly for replicate 3
samtools view -b -q 10 "$bam_replicate3" > "$filtered_bam_replicate3"
bedtools bamtofastq -i "$filtered_bam_replicate3" -fq filtered_reads_replicate3.fastq
canu -p assembly_replicate3 -d "$assembly_output_replicate3" genomeSize=100m -pacbio-raw filtered_reads_replicate3.fastq useGrid=true gridOptions="--partition=batch --cpus-per-task=32 --ntasks=1 --time=24:00:00"



Assembly                    assembly_replicate3.contigs
# contigs (>= 0 bp)         90                         
# contigs (>= 1000 bp)      90                         
# contigs (>= 5000 bp)      61                         
# contigs (>= 10000 bp)     49                         
# contigs (>= 25000 bp)     23                         
# contigs (>= 50000 bp)     21                         
Total length (>= 0 bp)      39526528                   
Total length (>= 1000 bp)   39526528                   
Total length (>= 5000 bp)   39435646                   
Total length (>= 10000 bp)  39355232                   
Total length (>= 25000 bp)  38940400                   
Total length (>= 50000 bp)  38884479                   
# contigs                   90                         
Largest contig              5447697                    
Total length                39526528                   
GC (%)                      54.44                      
N50                         2996644                    
N90                         1039592                    
auN                         2836837.0                  
L50                         6                          
L90                         15                         
# N's per 100 kbp           0.00                       


2024-06-09 19:02:10 INFO:	Results:	C:97.7%[S:96.9%,D:0.8%],F:0.6%,M:1.7%,n:1706	   

2024-06-09 19:03:36 INFO:	

	---------------------------------------------------
	|Results from dataset ascomycota_odb10             |
	---------------------------------------------------
	|C:97.7%[S:96.9%,D:0.8%],F:0.6%,M:1.7%,n:1706      |
	|1667	Complete BUSCOs (C)                        |
	|1653	Complete and single-copy BUSCOs (S)        |
	|14	Complete and duplicated BUSCOs (D)         |
	|11	Fragmented BUSCOs (F)                      |
	|28	Missing BUSCOs (M)                         |
	|1706	Total BUSCO groups searched                |
	---------------------------------------------------



# MAking a consensus genome assembly..ml minimap2/2.24-GCCcore-11.3.0
ml miniasm/0.3-20191007-GCCcore-11.3.0
ml Racon/1.5.0-GCCcore-11.3.0
ml SAMtools/1.16.1-GCC-11.3.0
ml BCFtools/1.15.1-GCC-11.3.0

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

ml BUSCO/5.5.0-foss-2022a

busco -f -i test_consensus.fasta -l ascomycota_odb10 -o busco -m genome -c 4

module load QUAST/5.2.0-foss-2022a

quast test_consensus.fasta -o quast


# BUSCO version is: 5.5.0 
# The lineage dataset is: ascomycota_odb10 (Creation date: 2024-01-08, number of genomes: 365, number of BUSCOs: 1706)
# Summarized benchmarking in BUSCO notation for file /scratch/sp47126/Akshaya_Seq/Consensus_Assembly/test_consensus.fasta
# BUSCO was run in mode: euk_genome_met
# Gene predictor used: metaeuk

	***** Results: *****

	C:97.9%[S:97.1%,D:0.8%],F:0.5%,M:1.6%,n:1706	   
	1670	Complete BUSCOs (C)			   
	1656	Complete and single-copy BUSCOs (S)	   
	14	Complete and duplicated BUSCOs (D)	   
	9	Fragmented BUSCOs (F)			   
	27	Missing BUSCOs (M)			   
	1706	Total BUSCO groups searched		   

Assembly Statistics:
	90	Number of scaffolds
	90	Number of contigs
	39801790	Total length
	0.000%	Percent gaps
	3 MB	Scaffold N50
	3 MB	Contigs N50


Dependencies and versions:
	hmmsearch: 3.3
	bbtools: 39.01
	metaeuk: GITDIR-NOTFOUND
	busco: 5.5.0
sp47126@ss-sub1 busco$ 



Assembly                    test_consensus
# contigs (>= 0 bp)         90            
# contigs (>= 1000 bp)      90            
# contigs (>= 5000 bp)      61            
# contigs (>= 10000 bp)     49            
# contigs (>= 25000 bp)     23            
# contigs (>= 50000 bp)     21            
Total length (>= 0 bp)      39801790      
Total length (>= 1000 bp)   39801790      
Total length (>= 5000 bp)   39710908      
Total length (>= 10000 bp)  39630494      
Total length (>= 25000 bp)  39215555      
Total length (>= 50000 bp)  39150514      
# contigs                   90            
Largest contig              5468643       
Total length                39801790      
GC (%)                      54.40         
N50                         3014066       
N90                         1058628       
auN                         2849831.2     
L50                         6             
L90                         15            
# N's per 100 kbp           0.00          
sp47126@ss-sub1 quast$ 

# Load FunAnnotate module
ml funannotate/1.8.15

# Activate FunAnnotate conda environment
source activate ${EBROOTFUNANNOTATE}


# Define input and output files
input_fasta="Final_filtered_contigs.fasta"
output_dir="funannotate_output1"
species_name="Microdochium fisheri"

# Mask the repeated genome assembly
funannotate mask \
    --input $input_fasta \
    --out $output_dir/masked.fasta \
    --cpus 30

# Run FunAnnotate predict on the masked assembly
funannotate predict \
    --input $output_dir/masked.fasta \
    --species "$species_name" \
    --cpus 30 \
    --out $output_dir \
    --genemark_mode ES \
    --busco_db fungi










