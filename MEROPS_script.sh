#!/bin/bash
#SBATCH --job-name=Mmaydis_MEROPS
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=06:00:00
#SBATCH --output=Mmaydis_MEROPS_%j.out
#SBATCH --error=Mmaydis_MEROPS_%j.err
#SBATCH --mail-user=sp47126@uga.edu
#SBATCH --mail-type=END,FAIL

set -euo pipefail

module purge
module load DIAMOND/2.1.23-GCC-13.3.0

BASE="/scratch/sp47126/Akshaya_Seq/Consensus_Assembly/GENE_PREDICTION/FINAL_RESULTS_Only/After_contamination_removal"
WORKDIR="${BASE}/functional_annotation/MEROPS"
PROT="${BASE}/funannotate_predict_output/predict_results/Monographella_maydis.proteins.fa"

mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

echo "=== Working directory ==="
pwd
echo

echo "=== Checking inputs ==="
[[ -f "merops_pepunit.clean.fa" ]] || { echo "ERROR: missing merops_pepunit.clean.fa"; exit 1; }
[[ -f "${PROT}" ]] || { echo "ERROR: missing protein FASTA: ${PROT}"; exit 1; }
echo

echo "=== Building DIAMOND database ==="
if [[ ! -f "MEROPS.dmnd" ]]; then
  diamond makedb --in merops_pepunit.clean.fa -d MEROPS
fi
echo

echo "=== Running MEROPS annotation ==="
diamond blastp \
  -q "${PROT}" \
  -d "${WORKDIR}/MEROPS" \
  -o "${WORKDIR}/MEROPS_hits.tsv" \
  --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore \
  -e 1e-5 \
  -k 1 \
  --threads 32

echo
echo "=== DONE ==="
ls -lh "${WORKDIR}"
