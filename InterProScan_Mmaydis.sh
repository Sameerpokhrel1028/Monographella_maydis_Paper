WD="/scratch/sp47126/Akshaya_Seq/Consensus_Assembly/GENE_PREDICTION/FINAL_RESULTS_Only/After_contamination_removal"
PROTEINS="${WD}/funannotate_predict_output/predict_results/Monographella_maydis.proteins.fa"
OUTDIR="${WD}/functional_annotation/interproscan"
PREFIX="${OUTDIR}/Mmaydis_interpro"


module load InterProScan
module load InterProScan_data

interproscan.sh \
    -i "${PROTEINS}" \
    -b "${PREFIX}" \
    -f TSV,XML,GFF3 \
    -goterms \
    -iprlookup \
    --cpu "${SLURM_CPUS_PER_TASK}"

