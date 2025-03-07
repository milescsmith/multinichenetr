% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotting.R
\name{make_ligand_activity_plots}
\alias{make_ligand_activity_plots}
\title{make_ligand_activity_plots}
\usage{
make_ligand_activity_plots(prioritization_tables, ligands_oi, contrast_tbl, widths = NULL)
}
\arguments{
\item{prioritization_tables}{Output of `generate_prioritization_tables` or sublist in the output of `multi_nichenet_analysis`}

\item{ligands_oi}{Character vector of ligands for which the activities should be visualized}

\item{contrast_tbl}{Table to link the contrast definitions to the group ids.}

\item{widths}{Vector of 2 elements: Width of the scaled ligand activity panel, width of the ligand activity panel. Default NULL: automatically defined based number of group-receiver combinations. If manual change: example format: c(3,2)}
}
\value{
Heatmap of ligand activities (normal and scaled) of each group-receiver combination
}
\description{
\code{make_ligand_activity_plots}  Visualize the ligand activities (normal and scaled) of each group-receiver combination
}
\examples{
\dontrun{

library(dplyr)
lr_network <- readRDS(url("https://zenodo.org/record/3260758/files/lr_network.rds"))
lr_network <- lr_network \%>\%
  dplyr::rename(ligand = from, receptor = to) \%>\%
  dplyr::distinct(ligand, receptor)
ligand_target_matrix <- readRDS(url("https://zenodo.org/record/3260758/files/ligand_target_matrix.rds"))
sample_id <- "tumor"
group_id <- "pEMT"
celltype_id <- "celltype"
batches <- NA
contrasts_oi <- c("'High-Low','Low-High'")
contrast_tbl <- tibble(contrast = c("High-Low", "Low-High"), group = c("High", "Low"))
output <- multi_nichenet_analysis(
  sce = sce,
  celltype_id = celltype_id,
  sample_id = sample_id,
  group_id = group_id,
  batches = batches,
  lr_network = lr_network,
  ligand_target_matrix = ligand_target_matrix,
  contrasts_oi = contrasts_oi,
  contrast_tbl = contrast_tbl
)
ligands_oi <- output$prioritization_tables$ligand_activities_target_de_tbl \%>\%
  inner_join(contrast_tbl) \%>\%
  group_by(group, receiver) \%>\%
  distinct(ligand, receiver, group, activity) \%>\%
  top_n(5, activity) \%>\%
  dplyr::pull(ligand) \%>\%
  unique()
plot_oi <- make_ligand_activity_plots(output$prioritization_tables, ligands_oi, contrast_tbl)
plot_oi
}

}
