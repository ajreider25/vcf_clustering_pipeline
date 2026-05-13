# VCF Clustering Pipeline

End-to-end Snakemake workflow for VCF preprocessing, genotype matrix generation, clustering, and PCA visualization using Python and R.

## Overview

This project demonstrates a reproducible genomics workflow built with:

* Snakemake
* Python
* R
* Docker/Dev Containers
* VS Code

The pipeline:

1. Parses a VCF file
2. Extracts genotype information
3. Generates a genotype matrix
4. Clusters samples using KMeans
5. Produces PCA visualizations of sample clusters

---

## Repository Structure

```text
VCF_Clustering_Pipeline/
├── .devcontainer/
├── data/
│   ├── raw/
│   └── processed/
├── results/
│   ├── clusters/
│   └── figures/
├── scripts/
├── Snakefile
├── config.yaml
├── environment.yml
└── README.md
```

---

## Pipeline Workflow

```text
VCF
  ↓
Genotype Matrix
  ↓
Sample Clustering
  ↓
PCA Visualization
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

---

## Example Output

The workflow generates:

* Variant metadata tables
* Genotype matrices
* Sample cluster assignments
* PCA cluster visualization PDFs

Example outputs:

```text
data/processed/genotype_matrix.tsv
results/clusters/clusters.tsv
results/figures/pca_clusters.pdf
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

### Environment Management

* Docker
* Dev Containers
* Conda/Mamba

---

## Future Improvements

Potential next steps:

* Variant filtering
* Missingness handling
* MAF filtering
* Additional clustering methods
* Interactive visualizations
* Workflow scaling for large VCFs
* Multi-sample real-world datasets

---

## License

MIT License
