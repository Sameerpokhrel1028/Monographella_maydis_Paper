set -eo pipefail

WD="/scratch/sp47126/Akshaya_Seq/Consensus_Assembly/GENE_PREDICTION/FINAL_RESULTS_Only/After_contamination_removal"
MASKED_GENOME="${WD}/repeatmasker_output/Mmaydis_genome_FINAL_noContamination_renamed_noGaps.fa.masked.cleaned"
OUTDIR="${WD}/funannotate_predict_output"
SPECIES="Monographella maydis"

cd "${WD}"

module purge
ml funannotate

funannotate predict \
    --input "${MASKED_GENOME}" \
    --species "${SPECIES}" \
    --cpus ${SLURM_CPUS_PER_TASK} \
    --out "${OUTDIR}" \
    --genemark_mode ES \
    --busco_db fungi \
    --augustus_species neurospora_crassa
