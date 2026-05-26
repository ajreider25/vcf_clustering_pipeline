from pathlib import Path

configfile: "config.yaml"

VCF_NAME = Path(config["vcf"]).stem.replace(".vcf","")

RUN_NAME = (
    f"{VCF_NAME}_{config['processing']['max_variants']}"
)

VARIANTS_TSV = (
    f"data/processed/{RUN_NAME}/variants.tsv"
)

FILTERED_VCF = (
    f"data/processed/{RUN_NAME}/filtered.vcf.gz"
)

GENOTYPE_MATRIX = (
    f"data/processed/{RUN_NAME}/genotype_matrix.tsv"
)

CLUSTERS = (
    f"results/{RUN_NAME}/clusters.tsv"
)

PCA_PLOT = (
    f"results/{RUN_NAME}/pca_clusters.pdf"
)

rule all:
    input:
        PCA_PLOT

rule filter_vcf:
    input:
        config["vcf"]
    output:
        vcf=FILTERED_VCF,
        index=f"{FILTERED_VCF}.csi"
    benchmark:
        "benchmarks/filter_vcf.txt"
    params:
        region=config["filtering"]["region"],
        min_qual=config["filtering"]["min_qual"],
        variant_type=config["filtering"]["keep_variant_type"],
        min_alleles=config["filtering"]["min_alleles"],
        max_alleles=config["filtering"]["max_alleles"]
    shell:
        """
        bcftools view \
            -r {params.region} \
            -m{params.min_alleles} -M{params.max_alleles} \
            -v {params.variant_type} \
            -i 'QUAL>={params.min_qual}' \
            -Oz \
            -o {output.vcf} \
            {input}

        bcftools index --csi {output.vcf}
        """

rule preprocess_vcf:
    input:
        vcf=FILTERED_VCF,
        index=f"{FILTERED_VCF}.csi"
    output:
        VARIANTS_TSV
    shell:
        """
        python scripts/preprocess_vcf.py \
            {input} \
            {output}
        """

rule make_genotype_matrix:
    input:
        vcf=FILTERED_VCF,
        index=f"{FILTERED_VCF}.csi"
    output:
        GENOTYPE_MATRIX
    benchmark:
        "benchmarks/make_genotype_matrix.txt"
    params:
        max_variants=config["processing"]["max_variants"]
    shell:
        """
        python scripts/make_genotype_matrix.py \
            {input.vcf} \
            {output} \
            {params.max_variants}
        """    

rule cluster_samples:
    input:
        GENOTYPE_MATRIX
    output:
        CLUSTERS
    benchmark:
        "benchmarks/cluster_samples.txt"
    params:
        n_clusters=config["clustering"]["n_clusters"],
        seed=config["clustering"]["random_seed"]
    shell:
        """
        python scripts/cluster_samples.py \
            {input} \
            {output} \
            {params.n_clusters} \
            {params.seed}
        """

rule plot_clusters:
    input:
        genotype=GENOTYPE_MATRIX,
        clusters=CLUSTERS
    output:
        PCA_PLOT
    benchmark:
        "benchmarks/plot_clusters.txt"
    shell:
        """
        Rscript scripts/plot_clusters.R \
            {input.genotype} \
            {input.clusters} \
            {output}
        """