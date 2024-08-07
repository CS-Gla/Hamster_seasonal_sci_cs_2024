# If need to install then uncomment below

#install.packages("BiocManager")
#install.packages("tidyverse")
#need r version 4.1.0 for this to function
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install(version = "3.13")
#BiocManager::install("ComplexHeatmap")



#Load required libraries
library(ComplexHeatmap)
library(rstudioapi)
library(tidyverse)
library(ggplot2)
library(grid) 
library(RColorBrewer) 
library(gdata)
library(plots) 
library(reshape2)
library(circlize)
library(ggstatsplot)
library(klustR)
library(dplyr)
library(factoextra)


#Load zscores of significant transcripts from Biodare
setwd(dirname(getActiveDocumentContext()$path))
z_scores_pvn <- read_excel("zscores.xlsx")

#If you have to transpose first
#z_scores = as.data.frame(t(z_scores))

#Build heatdata object
heat_arc = z_scores_arc
row.names(heat_arc) = heat_arc$Gene
names_arc = row.names(heat_arc)
heatdata_arc = heat_arc[, -1]
row.names(heatdata_arc) = row.names(heat_arc)


#Utilise GAP statistic analysis to determine number of clusters within the data
gap_stat <- cluster::clusGap(heatdata_arc, FUN = kmeans, nstart = 30, K.max = 5, B = 50, iter.max=50)
gap = fviz_gap_stat(gap_stat) + theme_minimal() + ggtitle("Gap Statistic")
gap


# fix order of the clusters to have 1 to 4, top to bottom
#pamClusters$clustering <- factor(pamClusters$clustering,
#levels = c('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4'))

#Correct row name and carry out pam clustering based on GAP ststistic clusters
row.names(heatdata_arc) = sub(".* ","", names_arc)
heatdata_arc = as.matrix(heatdata_arc)
colnames(heatdata_arc) = factor(colnames(heatdata_arc), levels = c("0", "4", "8", "12", "16", "20", "24", "28", "32"))
pamClusters_arc <- cluster::pam(heatdata_arc, k = 4) # pre-select k = n centers
Clusters_arc <- cluster::pam(heatdata_arc, k = 4)
pamClusters1_arc <- fpc::pamk(heatdata_arc)
pamClusters_arc$clustering <- paste0('', pamClusters_arc$clustering)



#Build density heatmap function
panel_fun_density = function(index, nm) {
  ht = densityHeatmap(heatdata_arc[index, ],  column_title = "", ylab = NULL, show_heatmap_legend = FALSE, quantile_gp = gpar(fontsize = 5))
  g = grid.grabExpr(draw(ht))
  grid.draw(g)
}

densityHeatmap()



#Build and draw heatmap, including density heatmap
h_arc = Heatmap(heatdata_arc, 
            name = "z scores",
            col=colorRamp2(c(-1, 0, 1), c("blue", "white", "red")), # <Aesthetics
            show_row_names = T,
            show_row_dend = F,
            row_names_side = "left",
            row_title = "Arcuate",
            row_names_gp = gpar(fontsize = 10),
            column_order = c("0", "4", "8", "12", "16", "20", "24", "28", "32"),
            #row_ha = rowAnnotation(foo = runif(n), bar1= anno_barplot(n)),
            #right_annotation = boxplotRow,
            row_split = factor(pamClusters_arc$clustering, levels = c(3, 7, 5, 4, 6, 10, 8, 2, 9, 1)), #< To reorder the clusters
            cluster_row_slices = T, # < T = software will cluster the clusters, F = use the order you specify
            #clustering_distance_rows = "kendall",
            row_dend_reorder = F,
            #row_km = 2,
            right_annotation = rowAnnotation(foo = anno_link(align_to = pamClusters_arc$clustering, panel_fun = panel_fun_density, which = c("row"), gap = unit(0.1, "cm"), size = 5, width = unit(7, "cm"),))
            #right_annotation = rowAnnotation(foo = anno_zoom(align_to = pamClusters_arc$medoids, panel_fun = panel_fun, which = c("row"), size = 5, gap = unit(1, "cm"), width = unit(4, "cm")))
)

draw(h_arc, heatmap_legend_side = "left")


#Save heatmap as PDF
pdf(file = "heatmap.pdf")
draw(h_arc)
dev.off()
