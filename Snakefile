configfile: "config.yaml"


rule all:
    input:
        config["outputs"]["pca_plot"]


rule preprocess_vcf:
    input:
        config["vcf"]
    output:
        config["outputs"]["variants"]
    shell:
        """
        python scripts/preprocess_vcf.py \
            {input} \
            {output}
        """

rule filter_vcf:
    input:
        config["vcf"]
    output:
        vcf="data/processed/filtered.vcf.gz",
        index="data/processed/filtered.vcf.gz.csi"
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

rule make_genotype_matrix:
    input:
        vcf="data/processed/filtered.vcf.gz",
        index="data/processed/filtered.vcf.gz.csi"
    output:
        config["outputs"]["genotype_matrix"]
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
        config["outputs"]["genotype_matrix"]
    output:
        config["outputs"]["clusters"]
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
        genotype=config["outputs"]["genotype_matrix"],
        clusters=config["outputs"]["clusters"]
    output:
        config["outputs"]["pca_plot"]
    shell:
        """
        Rscript scripts/plot_clusters.R \
            {input.genotype} \
            {input.clusters} \
            {output}
        """