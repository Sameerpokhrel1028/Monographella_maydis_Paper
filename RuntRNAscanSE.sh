set -euo pipefail

module purge
module load tRNAscan-SE

BASE="/scratch/sp47126/Akshaya_Seq/Consensus_Assembly/GENE_PREDICTION"

GENOME="${BASE}/FINAL_RESULTS_Only/After_contamination_removal/Mmaydis_genome_FINAL_noContamination_renamed_noGaps.fa"

OUTDIR="${BASE}/FINAL_RESULTS_Only/After_contamination_removal/tRNAscanSE"
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

echo "=== Input check ==="
echo "Genome: $GENOME"
echo "OUTDIR: $OUTDIR"
echo

[[ -f "$GENOME" ]] || { echo "ERROR: genome not found: $GENOME"; exit 1; }

echo "=== tRNAscan-SE check ==="
which tRNAscan-SE
tRNAscan-SE --version || true
echo

echo "=== Running dedicated tRNA prediction ==="

tRNAscan-SE \
  --thread 16 \
  -E \
  -o Mmaydis_tRNAscanSE.out \
  -f Mmaydis_tRNAscanSE.ss \
  -m Mmaydis_tRNAscanSE.stats \
  -a Mmaydis_tRNAscanSE.fa \
  "$GENOME"

echo
echo "=== Making GFF3 from tRNAscan-SE output ==="

awk '
BEGIN {
    OFS="\t";
    print "##gff-version 3";
}
NR > 3 && $1 !~ /^Sequence/ && NF >= 9 {
    seqid=$1;
    trna_num=$2;
    start=$3;
    end=$4;
    type=$5;
    anticodon=$6;
    intron_start=$7;
    intron_end=$8;
    score=$9;

    strand="+";
    if (start > end) {
        tmp=start;
        start=end;
        end=tmp;
        strand="-";
    }

    id="tRNA_" trna_num;
    name="tRNA-" type "-" anticodon;

    print seqid, "tRNAscan-SE", "tRNA", start, end, score, strand, ".", \
          "ID=" id ";Name=" name ";product=tRNA-" type ";anticodon=" anticodon;
}
' Mmaydis_tRNAscanSE.out > Mmaydis_tRNAscanSE.gff3

echo
echo "=== Making summary ==="

TRNA_COUNT=$(grep -P "\ttRNA\t" Mmaydis_tRNAscanSE.gff3 | wc -l)

{
    echo -e "Feature\tCount"
    echo -e "tRNA\t${TRNA_COUNT}"
} > Mmaydis_tRNAscanSE_summary.tsv

echo
echo "Summary:"
column -t -s $'\t' Mmaydis_tRNAscanSE_summary.tsv || cat Mmaydis_tRNAscanSE_summary.tsv

echo
echo "Top predicted tRNAs:"
grep -P "\ttRNA\t" Mmaydis_tRNAscanSE.gff3 | head -20 || true

echo
echo "Outputs:"
ls -lh "$OUTDIR"

echo
echo "Done."
