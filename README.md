Genome Assembly
   ↓
Contamination Screening & Removal
   ↓
Repeat Identification (RepeatModeler)
   ↓
Repeat Masking (RepeatMasker)
   ↓
Masked Clean Genome
   ↓
Funannotate Predict
   ├── GeneMark-ES (self-training)
   ├── BUSCO (fungi) → conserved genes
   ├── AUGUSTUS (pretrained: Neurospora crassa)
   ├── SNAP + GlimmerHMM
   ├── Protein alignment (miniprot)
   ↓
Evidence Integration (EVM)
   ↓
Final Gene Models (GFF3, proteins, CDS)

AUGUSTUS training using BUSCO-derived gene models was not feasible due to insufficient validated models (187 < 200). Therefore, a pretrained gene model from Neurospora crassa, a well-established model filamentous fungus within the class Sordariomycetes, was used due to its phylogenetic proximity and high-quality curated gene structure parameters.
