#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ComplexHeatmap)
  library(circlize)
  library(tools)
  library(grid)
})

infile <- "mash_dist.clean"

# ----------------------------
# Read Mash distances
# ----------------------------
dist <- read.table(infile, stringsAsFactors = FALSE)
colnames(dist)[1:3] <- c("g1", "g2", "d")

genomes <- sort(unique(c(dist$g1, dist$g2)))

# Build symmetric distance matrix
mat <- matrix(0, nrow = length(genomes), ncol = length(genomes),
              dimnames = list(genomes, genomes))

for (i in seq_len(nrow(dist))) {
  mat[dist$g1[i], dist$g2[i]] <- dist$d[i]
  mat[dist$g2[i], dist$g1[i]] <- dist$d[i]
}
diag(mat) <- 0

# ----------------------------
# Clean labels to Genus.species
#   M.nivale.fna                 -> M.nivale

# ----------------------------
clean_gspecies <- function(x) {
  x <- file_path_sans_ext(basename(x))
  sub("^([A-Za-z]+\\.[A-Za-z]+).*", "\\1", x)
}

lab <- clean_gspecies(rownames(mat))
rownames(mat) <- lab
colnames(mat) <- lab

# If duplicates happen after shortening, make unique so clustering/heatmap doesn't break
rownames(mat) <- make.unique(rownames(mat))
colnames(mat) <- rownames(mat)

# ----------------------------
# Clustering (dendrogram branches)
# ----------------------------
d <- as.dist(mat)
hc <- hclust(d, method = "average")

# ----------------------------
# Color scale
# ----------------------------
vals <- as.vector(mat)
vals <- vals[is.finite(vals)]

# ----- Sensitive green → blue → red scale -----

minv <- min(mat)
maxv <- max(mat)

scaled_mat <- (mat - minv) / (maxv - minv)

# More sensitive: extra breakpoints (especially near 0)
col_fun <- colorRamp2(
  c(0, 0.10, 0.25, 0.40, 0.60, 0.80, 1.00),
  c("#00441b", "#1a9850", "#66bd63", "#2c7bb6", "#fdae61", "#f46d43", "#a50026")
)

# ----------------------------
# Heatmap with dendrograms
# ----------------------------
ht <- Heatmap(
  scaled_mat,
  name = "MashDist",
  col = col_fun,
  cluster_rows = as.dendrogram(hc),
  cluster_columns = as.dendrogram(hc),
  show_row_dend = TRUE,
  show_column_dend = TRUE,
  row_dend_width = unit(30, "mm"),
  column_dend_height = unit(30, "mm"),
  row_names_side = "left",
  column_names_side = "bottom",
  row_names_gp = gpar(fontsize = 10, fontface = "bold"),
  column_names_gp = gpar(fontsize = 10, fontface = "bold"),
  column_names_rot = 45,
  heatmap_legend_param = list(
    title = "Mash distance",
    title_gp = gpar(fontface = "bold"),
    labels_gp = gpar(fontsize = 10)
  )
)

pdf("mash_distance_heatmap_dendrogram.pdf", width = 10, height = 9, useDingbats = FALSE)
draw(ht, heatmap_legend_side = "right")
dev.off()

cat("✔ Wrote: mash_distance_heatmap_dendrogram.pdf\n")
cat("Distance range used for colors: min=", minv, " max=", maxv, "\n")