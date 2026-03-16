

module purge
module load DIAMOND
module load MAFFT
module load FastTree
module load OrthoFinder

# Input proteomes 

PROTEOMES=(
  "M.maydis.protein.fasta"
  "M.nivale.protein.faa"
  "M.bolleyi.protein.faa"
  "M.trichoclapdiosis.protein.faa"
  "P.maydis.protein.faa"
  "F.graminiarum.protein.faa"
  "F.verticillioides.protein.faa"
)

# Clean + header-prefix proteomes

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



# Run OrthoFinder

echo "Starting OrthoFinder..."
orthofinder -f "$CLEAN_DIR" -t "$SLURM_CPUS_PER_TASK"
