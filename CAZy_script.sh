#!/bin/bash
#SBATCH --job-name=Mmaydis_dbCAN
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=08:00:00
#SBATCH --output=dbCAN_%j.out
#SBATCH --error=dbCAN_%j.err

set -euo pipefail

module purge
module load Python/3.11.3-GCCcore-12.3.0
module load HMMER/3.4-gompi-2024a
module load DIAMOND/2.1.23-GCC-13.3.0
module load prodigal/2.6.3-GCCcore-13.3.0

# Paths
BASE="/scratch/sp47126/Akshaya_Seq/Consensus_Assembly/GENE_PREDICTION/FINAL_RESULTS_Only/After_contamination_removal"
PROT="${BASE}/funannotate_predict_output/predict_results/Monographella_maydis.proteins.fa"
OUTDIR="${BASE}/functional_annotation/dbCAN"
DB_DIR="${BASE}/run_dbcan/db"

mkdir -p "${OUTDIR}"

# Run dbCAN
python -m dbcan.cli.run_dbcan \
  "${PROT}" protein \
  --out_dir "${OUTDIR}" \
  --db_dir "${DB_DIR}" \
  --dia_cpu 32 \
  --hmm_cpu 32 \
  --tf_cpu 32
