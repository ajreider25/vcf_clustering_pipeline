args <- commandArgs(trailingOnly=TRUE)

genotype_file <- args[1]
cluster_file <- args[2]
output_file <- args[3]

genotypes <- read.table(
    genotype_file,
    header=TRUE,
    sep="\t",
    check.names=FALSE
)

clusters <- read.table(
    cluster_file,
    header=TRUE,
    sep="\t"
)

rownames(genotypes) <- genotypes$variant_id
genotypes$variant_id <- NULL

# transpose so rows = samples
X <- t(genotypes)

sample_names <- rownames(X)
variant_names <- colnames(X)

# convert to numeric matrix while preserving dimensions
X <- matrix(
    as.numeric(X),
    nrow=length(sample_names),
    ncol=length(variant_names),
    dimnames=list(sample_names, variant_names)
)

# remove variants with no variation across samples
variant_sd <- apply(X, 2, sd, na.rm=TRUE)
X <-X[, variant_sd > 0, drop=FALSE]

# stop early if no information variants remain
if (ncol(X) == 0){
    stop("No variable variants remain after filtering; PCA cannot be computed.")
}

pca <- prcomp(X, scale.=TRUE)

plot_df <- data.frame(
    sample=rownames(X),
    PC1=pca$x[,1],
    PC2=pca$x[,2]
)

write.table(
    plot_df,
    file="results/figures/pca_coordinates.tsv",
    sep="\t",
    quote=FALSE,
    row.names=FALSE
)

plot_df <- merge(plot_df, clusters, by="sample")

pdf(output_file)

plot(
    plot_df$PC1,
    plot_df$PC2,
    col=plot_df$cluster + 1,
    pch=19,
    cex=0.7,
    xlab="PC1",
    ylab="PC2",
    main="Sample Clusters"
)

dev.off()