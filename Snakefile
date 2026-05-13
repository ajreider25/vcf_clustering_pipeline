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


rule make_genotype_matrix:
    input:
        config["vcf"]
    output:
        config["outputs"]["genotype_matrix"]
    shell:
        """
        python scripts/make_genotype_matrix.py \
            {input} \
            {output}
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