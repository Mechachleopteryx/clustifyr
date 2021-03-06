% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/common_dplyr.R
\name{collapse_to_cluster}
\alias{collapse_to_cluster}
\title{From per-cell calls, take highest freq call in each cluster}
\usage{
collapse_to_cluster(res, metadata, cluster_col, threshold = 0)
}
\arguments{
\item{res}{dataframe of idents, such as output of cor_to_call}

\item{metadata}{input metadata with tsne or umap coordinates and cluster ids}

\item{cluster_col}{metadata column for cluster}

\item{threshold}{minimum correlation coefficent cutoff for calling clusters}
}
\value{
new metadata with added columns
}
\description{
From per-cell calls, take highest freq call in each cluster
}
\examples{
res <- clustify(
    input = pbmc_matrix_small,
    metadata = pbmc_meta,
    cluster_col = "classified",
    ref_mat = cbmc_ref,
    per_cell = TRUE
)

res2 <- cor_to_call(res)

collapse_to_cluster(
    res2,
    metadata = pbmc_meta,
    cluster_col = "classified",
    threshold = 0
)
}
