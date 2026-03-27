set -euo pipefail

module purge
module load DIAMOND
module load MAFFT
module load FastTree
module load OrthoFinder

cd "$WORKDIR"


PROTEOMES=(
  "M.maydis.protein.faa"
  "M.nivale.protein.faa"
  "M.bolleyi.protein.faa"
  "M.trichoclapdiosis.protein.faa"
  "P.maydis.protein.faa"
  "F.graminiarum.protein.faa"
  "F.verticillioides.protein.faa"
)


CLEAN_DIR="proteomes_clean"
mkdir -p "$CLEAN_DIR"


for f in "${PROTEOMES[@]}"; do
  base="$(basename "$f")"
  species="${base%%.protein.*}"
  out="$CLEAN_DIR/${species}.faa"

  echo "  -> $f  =>  $out"

  awk -v sp="$species" '
    /^>/ {
      gsub(/[ \t\r]/, "_", $0)
      print ">", sp, "|", substr($0, 2)
      next
    }
    {
      line=toupper($0)
      gsub(/[^ACDEFGHIKLMNPQRSTVWYBX\*]/, "", line)
      if (length(line) > 0) print line
    }
  ' "$f" > "$out"

  if ! grep -q "^>" "$out"; then
    echo "ERROR: cleaned file has no FASTA headers: $out" >&2
    exit 1
  fi
done

ls -lh "$CLEAN_DIR"


orthofinder -f "$CLEAN_DIR" -t "$SLURM_CPUS_PER_TASK"
