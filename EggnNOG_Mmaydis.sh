set -euo pipefail


WD="/scratch/sp47126/Akshaya_Seq/Consensus_Assembly/GENE_PREDICTION/FINAL_RESULTS_Only/After_contamination_removal"
PROTEINS="${WD}/funannotate_predict_output/predict_results/Monographella_maydis.proteins.fa"
OUTDIR="${WD}/functional_annotation/eggnog"

module load eggnog-mapper

emapper.py \
    -i "${PROTEINS}" \
    --itype proteins \
    --output Mmaydis_eggnog \
    --output_dir "${OUTDIR}" \
    --cpu "${SLURM_CPUS_PER_TASK}"

