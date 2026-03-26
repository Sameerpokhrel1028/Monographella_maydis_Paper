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
   ├── Evidence-based gene prediction (protein alignments)
   ├── Ab initio gene prediction (GeneMark-ES, AUGUSTUS, SNAP, GlimmerHMM)
   ├── Gene model training and optimization (BUSCO-guided)
   └── Consensus gene model generation (EvidenceModeler, EVM)
   ↓
Final Gene Models
   ├── GFF3
   ├── Proteins (FASTA)
   ├── CDS (FASTA)
   ├── TBL
   ├── GBK
   ↓
Functional Annotation
   ├── InterProScan (v5.76-107.0)
   │    ├── Domain annotation (Pfam, SMART, CDD, etc.)
   │    ├── InterPro accessions
   │    └── Gene Ontology (GO) assignment
   │
   ├── eggNOG-mapper (v2.1.12-foss-2023a)
   │    ├── Ortholog identification
   │    ├── Functional descriptions
   │    ├── COG classification
   │    └── KEGG pathway annotation

```
AUGUSTUS training using BUSCO-derived gene models was not feasible due to insufficient validated models (187 < 200 required). Therefore, a pretrained gene model from Neurospora crassa, a well-established model filamentous fungus within the class Sordariomycetes (same as Monographella), was used due to its phylogenetic proximity and high-quality, curated gene-structure parameters. The pre-trained set was available in the UGA cluster.
