
cd "$WORKDIR"


module purge
module load GCCcore/12.3.0
module load Mash/2.3-GCC-12.3.0
module load R-bundle-Bioconductor/3.18-foss-2023a-R-4.3.2


STEP 1 — Mash sketch

mkdir -p mashdb
mash sketch \
  -p "$SLURM_CPUS_PER_TASK" \
  -o mashdb/genomes \
  "$WORKDIR"/*.fna

 STEP 2 — Mash distances

mash dist \
  -p "$SLURM_CPUS_PER_TASK" \
  mashdb/genomes.msh mashdb/genomes.msh \
  > mash_dist.txt


STEP 3 — Clean formatting (required by R script)
awk '{print $1,$2,$3}' mash_dist.txt > mash_dist.clean
sed -i 's/\t/ /g' mash_dist.clean


STEP 4 — Heatmap + dendrogram in R

Rscript Final_Rscript_heatmap.R

