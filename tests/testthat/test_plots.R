context("plotting")

res <- clustify(
    input = pbmc_matrix_small,
    metadata = pbmc_meta,
    ref_mat = cbmc_ref,
    query_genes = pbmc_vargenes,
    cluster_col = "classified"
)

res2 <- clustify(
    input = pbmc_matrix_small,
    metadata = pbmc_meta,
    ref_mat = cbmc_ref,
    query_genes = pbmc_vargenes,
    cluster_col = "classified",
    per_cell = TRUE
)

test_that("plots can be generated", {
    plts <- plot_best_call(res,
        pbmc_meta,
        cluster_col = "classified"
    )
    plts2 <- plot_dims(pbmc_meta)
    expect_true(ggplot2::is.ggplot(plts))
})

test_that("plot_best_call warns about colnames", {
    pbmc_meta2 <- pbmc_meta
    pbmc_meta2$type <- 1
    expect_warning(plts <- plot_best_call(res, pbmc_meta2))
})

test_that("call plots can be generated", {
    plts <- plot_cor(
        res,
        pbmc_meta,
        cluster_col = "classified"
    )

    expect_error(
        plts <- plot_cor(
            res,
            pbmc_meta,
            data_to_plot = "nonsense",
            cluster_col = "classified"
        )
    )

    expect_true(is.list(plts))
    expect_true(ggplot2::is.ggplot(plts[[1]]))
})

test_that("plot_cor for all clusters by default", {
    plts <- plot_cor(res,
        pbmc_meta,
        cluster_col = "classified",
        x = "UMAP_1",
        y = "UMAP_2"
    )

    plts2 <- plot_cor(
        res2,
        pbmc_meta %>% tibble::rownames_to_column("rn"),
        cluster_col = "rn",
        x = "UMAP_1",
        y = "UMAP_2"
    )

    expect_true(length(plts) == ncol(cbmc_ref))
})

test_that("plot_cor works with scale_legends option", {
    plts <- plot_cor(res,
        pbmc_meta,
        cluster_col = "classified",
        scale_legends = TRUE
    )

    plts2 <- plot_cor(res,
        pbmc_meta,
        cluster_col = "classified",
        scale_legends = c(0, 1)
    )
    expect_true(length(plts) == ncol(cbmc_ref))
})

test_that("plot_gene can handle strange and normal genenames", {
    genes <- c(
        "RP11-314N13.3",
        "ARF4"
    )
    plts <- plot_gene(
        pbmc_matrix_small,
        pbmc_meta %>% tibble::rownames_to_column("rn"),
        genes = genes,
        cell_col = "rn"
    )

    expect_true(is.list(plts))
    expect_true(all(vapply(plts, ggplot2::is.ggplot, FUN.VALUE = logical(1))))
})

test_that("plot_gene automatically plots all cells", {
    genes <- c("ZYX")
    expect_error(
        plts <- plot_gene(
            pbmc_matrix_small,
            tibble::column_to_rownames(pbmc_meta, "rn"),
            genes = genes,
            cell_col = "nonsense"
        )
    )

    plts <- plot_gene(pbmc_matrix_small,
        pbmc_meta,
        genes = genes
    )

    expect_true(all(vapply(plts, ggplot2::is.ggplot, FUN.VALUE = logical(1))))
})

test_that("plot_best_call threshold works as intended, on per cell and collapsing", {
    res <- clustify(
        input = pbmc_matrix_small,
        metadata = pbmc_meta,
        ref_mat = cbmc_ref,
        query_genes = pbmc_vargenes,
        cluster_col = "classified",
        per_cell = TRUE
    )
    call1 <- plot_best_call(
        res,
        metadata = pbmc_meta,
        per_cell = TRUE,
        collapse_to_cluster = "classified",
        threshold = 0.3
    )

    expect_true(ggplot2::is.ggplot(call1))
})

test_that("plot_gene checks for presence of gene name", {
    expect_message(plot_gene(pbmc_matrix_small,
        pbmc_meta %>% tibble::rownames_to_column("rn"),
        c("INIP", "ZFP36L3"),
        cell_col = "rn",
        do_label = TRUE,
        do_legend = FALSE,
        x = "UMAP_1",
        y = "UMAP_2"
    ))
    expect_error(expect_warning(plot_gene(pbmc_matrix_small,
        pbmc_meta %>% tibble::rownames_to_column("rn"),
        c("ZFP36L3"),
        cell_col = "rn",
        x = "UMAP_1",
        y = "UMAP_2"
    )))
})

test_that("plot_cor_heatmap returns a ggplot object", {
    res <- clustify(
        input = pbmc_matrix_small,
        metadata = pbmc_meta,
        ref_mat = cbmc_ref,
        query_genes = pbmc_vargenes,
        cluster_col = "classified",
        per_cell = FALSE
    )
    g <- plot_cor_heatmap(res)
    expect_true(is(g, "Heatmap"))
})

test_that("plot_call works on defaults", {
    g <- plot_call(res,
        pbmc_meta,
        cluster_col = "classified"
    )

    expect_true(ggplot2::is.ggplot(g[[1]]))
})

test_that("plot_dims works with alpha_col", {
    pbmc_meta2 <- pbmc_meta
    pbmc_meta2$al <- 0
    pbmc_meta2$al[1] <- 1
    g <- plot_dims(
        pbmc_meta2,
        feature = "classified",
        alpha_col = "al",
        do_legend = FALSE
    )
    g2 <- plot_dims(
        pbmc_meta2,
        feature = "classified",
        alpha_col = "al",
        do_legend = FALSE,
        do_repel = TRUE,
        do_label = TRUE
    )
    expect_true(ggplot2::is.ggplot(g))
})

test_that("plot_dims works with group_col", {
    pbmc_meta2 <- pbmc_meta
    pbmc_meta2$al <- 1
    pbmc_meta2$al[1:1500] <- 0
    pbmc_meta2$b <- pbmc_meta2$classified
    g <- plot_dims(
        pbmc_meta2,
        feature = "classified",
        group_col = "b",
        do_legend = FALSE,
        do_repel = TRUE,
        do_label = FALSE
    )

    g2 <- plot_dims(
        pbmc_meta2,
        feature = "classified",
        alpha_col = "al",
        group_col = "b",
        do_legend = FALSE,
        do_repel = TRUE,
        do_label = TRUE
    )
    expect_true(ggplot2::is.ggplot(g2))
})
