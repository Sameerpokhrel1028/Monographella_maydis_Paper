#!/bin/bash
#SBATCH --job-name=ProteomeTree
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=120G
#SBATCH --time=72:00:00
#SBATCH --output=orthofinder_%j.out
#SBATCH --error=orthofinder_%j.err

set -euo pipefail

##############################
# Modules
##############################
module purge
module load DIAMOND/2.1.15-GCC-13.3.0
module load MAFFT/7.526-GCC-13.3.0-with-extensions
module load FastTree/2.1.11-GCCcore-13.2.0
module load OrthoFinder/3.1.0-foss-2023a

##############################
# Working directory
##############################
WORKDIR=/scratch/sp47126/Akshaya_Seq/Phyllogenetic_Tree/Protein_PhyllogeneticTree/Proteomics
cd "$WORKDIR"

echo "Running in: $WORKDIR"
echo "CPU threads: $SLURM_CPUS_PER_TASK"

##############################
# Input proteomes 
##############################
PROTEOMES=(
  "M.maydis.protein.fasta"
  "M.nivale.protein.faa"
  "M.bolleyi.protein.faa"
  "M.trichoclapdiosis.protein.faa"
  "P.maydis.protein.faa"
  "F.graminiarum.protein.faa"
  "F.verticillioides.protein.faa"
)

# Sanity checking if inputs exist
echo "Checking input files..."
for f in "${PROTEOMES[@]}"; do
  if [[ ! -s "$f" ]]; then
    echo "ERROR: Missing/empty file: $WORKDIR/$f" >&2
    exit 1
  fi
done
echo "All input proteomes found."

##############################
# Clean + header-prefix proteomes
# (prevents ID collisions across species)
##############################
CLEAN_DIR="proteomes_clean"
rm -rf "$CLEAN_DIR"
mkdir -p "$CLEAN_DIR"

echo "Cleaning proteomes into: $WORKDIR/$CLEAN_DIR"
for f in "${PROTEOMES[@]}"; do
  base="$(basename "$f")"
  species="${base%%.protein.*}"      # e.g. M.nivale
  out="$CLEAN_DIR/${species}.faa"    # force .faa for OrthoFinder consistency

  echo "  -> $f  =>  $out"

  # 1) Prefix FASTA headers with species to ensure uniqueness
  # 2) Cleaning the sequence lines
  awk -v sp="$species" '
    BEGIN{FS=""; OFS=""}
    /^>/ {
      # Replace spaces and weird chars in header with underscores
      gsub(/[ \t\r]/, "_", $0)
      print ">", sp, "|", substr($0, 2)
      next
    }
    {
      # Uppercase
      line=$0
      gsub(/[a-z]/, toupper("&"), line)

      # Remove anything not standard AA letter, X, B, or *
      gsub(/[^ACDEFGHIKLMNPQRSTVWYBX\*]/, "", line)

      if (length(line) > 0) print line
    }
  ' "$f" > "$out"

  # Basic check: must contain at least one header and some sequence
  if ! grep -q "^>" "$out"; then
    echo "ERROR: cleaned file has no FASTA headers: $out" >&2
    exit 1
  fi
done

echo "Proteomes cleaned. Files:"
ls -lh "$CLEAN_DIR"


##############################
# Run OrthoFinder
##############################
echo "Starting OrthoFinder..."
orthofinder -f "$CLEAN_DIR" -t "$SLURM_CPUS_PER_TASK"

echo "OrthoFinder finished ✔"

##############################
# Report tree location(s)
##############################
echo "Species tree Newick files:"
find "$CLEAN_DIR/OrthoFinder" -type f \( -name "SpeciesTree_rooted.txt" -o -name "SpeciesTree_unrooted.txt" -o -name "*SpeciesTree*.txt" \) -print

echo "DONE ✔"