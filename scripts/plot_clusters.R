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

pca <- prcomp(X, scale.=TRUE)

plot_df <- data.frame(
    sample=rownames(pca$x),
    PC1=pca$x[,1],
    PC2=pca$x[,2]
)

plot_df <- merge(plot_df, clusters, by="sample")

pdf(output_file)

plot(
    plot_df$PC1,
    plot_df$PC2,
    col=plot_df$cluster + 1,
    pch=19,
    xlab="PC1",
    ylab="PC2",
    main="Sample Clusters"
)

text(
    plot_df$PC1,
    plot_df$PC2,
    labels=plot_df$sample,
    pos=3,
    cex=0.8
)

dev.off()