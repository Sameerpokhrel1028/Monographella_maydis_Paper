```
Genome Assembly
   ↓
Contamination Screening & Removal
   ↓
Repeat Identification (RepeatModeler v2.0.4)
   ↓
Repeat Masking (RepeatMasker v4.2.3)
   ↓
Masked Clean Genome
   ↓
Funannotate Predict (v1.8.17)
   ├── GeneMark-ES (v4.72; self-training)
   ├── BUSCO (fungi lineage)
   ├── AUGUSTUS (Neurospora crassa pretrained model)
   ├── SNAP
   ├── GlimmerHMM
   ├── Protein alignment (miniprot v0.13)
   ↓
Evidence Integration (EVM)
   ↓
Final Gene Models (GFF3, proteins, CDS, TBL, GBK)

```
AUGUSTUS training using BUSCO-derived gene models was not feasible due to insufficient validated models (187 < 200 required). Therefore, a pretrained gene model from Neurospora crassa, a well-established model filamentous fungus within the class Sordariomycetes (same as Monographella), was used due to its phylogenetic proximity and high-quality, curated gene-structure parameters. The pre-trained set was available in the UGA cluster.
