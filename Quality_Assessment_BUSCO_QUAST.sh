WD="/scratch/sp47126/Akshaya_Seq/Consensus_Assembly/GENE_PREDICTION/FINAL_RESULTS_Only"
GENOME="${WD}/Mmaydis_genome_FINAL_noContamination_renamed_noGaps.fa"

BUSCO_OUT="busco_Mmaydis_final"
QUAST_OUT="${WD}/quast_Mmaydis_final"

cd "${WD}"


module purge

module load BUSCO
module load QUAST

# Count contigs

echo "Contig count:"
grep -c "^>" "${GENOME}"

# Run BUSCO

# Using genome mode and fungi lineage
busco \
    -i "${GENOME}" \
    -o "${BUSCO_OUT}" \
    -m genome \
    -l fungi_odb10 \
    -c ${SLURM_CPUS_PER_TASK}


# Run QUAST

quast.py \
    "${GENOME}" \
    -o "${QUAST_OUT}" \
    --threads ${SLURM_CPUS_PER_TASK}
