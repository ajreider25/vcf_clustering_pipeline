# VCF Clustering Pipeline

End-to-end Snakemake workflow for VCF preprocessing, genotype matrix generation, clustering, and PCA visualization using Python and R.

## Overview

This project implements a reproducible end-to-end genomics workflow for processing Variant Call Format (VCF) files using Snakemake, Python, R, and bcftools.

The pipeline supports:

- VCF filtering with bcftools
- Region-restricted processing
- Configurable quality-control filtering
- Genotype matrix generation
- KMeans clustering
- PCA visualization
- Containerized reproducible execution with Docker Dev Containers

The workflow is designed to scale from toy datasets to real cohort-scale genomic data.

---

## Repository Structure

```text
VCF_Clustering_Pipeline/
├── .devcontainer/
├── data/
│   ├── raw/
│   └── processed/
├── results/
├── scripts/
├── Snakefile
├── config.yaml
├── environment.yml
└── README.md
```

---

## Pipeline Workflow

```text
Raw VCF (.vcf.gz)
    ↓
bcftools filtering / QC
    ↓
Filtered VCF
    ↓
Genotype matrix generation
    ↓
Sample clustering
    ↓
PCA visualization
```

---

## Configuration

Pipeline parameters are configured through `config.yaml`.

Example configurable parameters:

- Input VCF path
- Genomic region selection
- Quality filtering thresholds
- Variant count limits
- Clustering settings

Example:

```yaml
vcf: "data/raw/chr22.vcf.gz"

processing:
  max_variants: 5000
  
filtering:
  region: "22:16000000-17000000"
  min_qual: 30
```

---

## Requirements

Recommended setup:

* Docker Desktop
* VS Code
* Dev Containers extension

The environment is fully containerized using Docker and Conda/Mamba.

---

## Setup

Clone the repository:

```bash
git clone https://github.com/ajreider25/VCF_Clustering_Pipeline.git
cd VCF_Clustering_Pipeline
```

Open in VS Code and reopen in container:

```text
Dev Containers: Reopen in Container
```

---

## Running the Pipeline

Execute the full workflow:

```bash
snakemake --cores 1
```

Outputs are automatically organized into run-specific directories derived from the input VCF and processing parameters.

---

## Example Output

The workflow generates:

* Variant metadata tables
* Genotype matrices
* Sample cluster assignments
* PCA cluster visualization PDFs

Example outputs:

```text
data/processed/chr21_50000/genotype_matrix.tsv
results/chr21_50000/clusters.tsv
results/chr21_50000/pca_clusters.pdf
```

---

## Technologies Used

### Python

* cyvcf2
* pandas
* scikit-learn

### R

* base R PCA + plotting

### Workflow Management

* Snakemake

### Genomics Tools

* bcftools

### Environment Management

* Docker
* Dev Containers
* Conda/Mamba

---

## Future Improvements

Potential next steps:

* Additional clustering methods
* Interactive visualizations
* Sparse genotype matrix formats
* PLINK integration
* Dimensionality reduction alternatives (UMAP/t-SNE)
* Additional clustering algorithms
* Parallelized workflow execution
* Cloud/HPC deployment
* Improved missingness handling
* Large-scale cohort optimization

---

## License

MIT License

---

## Notes on Large VCFs

Large cohort-scale VCFs can require substantial runtime and memory resources.

Development workflows can be accelerated using:

- Region-restricted filtering
- Variant count limits
- Smaller chromosome subsets

These controls are configurable in `config.yaml`.