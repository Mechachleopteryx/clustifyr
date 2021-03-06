library(usethis)

s <- Seurat::pbmc_small
attr(attr(s, "class"), "package") <- NULL

attr(attr(s@commands$NormalizeData.RNA, "class"), "package") <- NULL
attr(attr(s@commands$FindVariableFeatures.RNA, "class"), "package") <- NULL
attr(attr(s@commands$ScaleData.RNA, "class"), "package") <- NULL
attr(attr(s@commands$RunPCA.RNA, "class"), "package") <- NULL
attr(attr(s@commands$BuildSNN.RNA.pca, "class"), "package") <- NULL
attr(attr(s@commands$FindClusters, "class"), "package") <- NULL
attr(attr(s@commands$RunTSNE.pca, "class"), "package") <- NULL
attr(attr(s@commands$JackStraw.RNA.pca, "class"), "package") <- NULL
attr(attr(s@commands$ScoreJackStraw.pca, "class"), "package") <- NULL
attr(attr(s@commands$ProjectDim.RNA.pca, "class"), "package") <- NULL
attr(attr(attr(s@reductions$pca, "jackstraw"), "class"), "package") <- NULL
attr(attr(s@reductions$pca, "class"), "package") <- NULL
attr(attr(s@reductions$tsne, "class"), "package") <- NULL
attr(attr(s@graphs$RNA_snn, "class"), "package") <- NULL
attr(attr(s@assays$RNA, "class"), "package") <- NULL
attr(attr(s@reductions$tsne@jackstraw, "class"), "package") <- NULL
s@commands <- list()
s_small3 <- s

usethis::use_data(s_small3, compress = "xz", overwrite = TRUE)
