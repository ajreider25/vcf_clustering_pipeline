pca25 <- read.table("results/figures/pca_25k.tsv", header=TRUE, sep="\t")
pca50 <- read.table("results/figures/pca_50k.tsv", header=TRUE, sep="\t")

pdf("results/figures/pca_overlay.pdf")

plot(
    pca25$PC1,
    pca25$PC2,
    col=rgb(1,0,0,0.4),
    pch=19,
    xlab="PC1",
    ylab="PC2",
    main="PCA Overlay: 25k vs 50k"
)

points(
    pca50$PC1,
    pca50$PC2,
    col=rgb(0,0,1,0.4),
    pch=19
)

legend(
    "topright",
    legend=c("25k", "50k"),
    col=c(rgb(1,0,0,0.4), rgb(0,0,1,0.4)),
    pch=19
)

dev.off()