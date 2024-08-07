
This repository contains code utitlised in the analysis of data for the publication BLANK. It was written to transform raw fast5 files produced by Oxford Nanopore Sequencing and produce quantifiable expression matrices.

NanoFlow1.sh and NanoFLow2.sh were ran on linux within conda. 

cDNA_DE.yml cotains conda environment details (Basecalling, filtering and quality assesment of nanopore reads was carried out within this environment). R file were ran within Rstudio.


The files included carry out the following functions;

NanoFLow1.sh: Basecall fast5 files to produce fastq files, trim and filter fastq files based on quality score and minimum length <br>
NanoFLow2.sh: Utilise minimap2 to align fastq files to a reference genome producing bam files, build expression matrix of sequencing using salmon <br>
NanoFlow_Report.Rmd: Utilises EdgeR to filter for lowly expressed transcripts, and identify differentially expressed transcripts. <br>

glmm.r: Used to build a gneral linear modle of Siberian hamster CRISPR data.


Requirements;
Guppy basecaller (https://community.nanoporetech.com/docs/prepare/library_prep_protocols/Guppy-protocol/v/gpb_2003_v1_revax_14dec2018/linux-guppy) <br>
Porechop (https://github.com/rrwick/Porechop) <br>
Filtlong (https://github.com/rrwick/Filtlong) <br>
Minimap2 (https://github.com/lh3/minimap2) <br>
Salmon (https://github.com/COMBINE-lab/salmon) <br>
EdgeR (https://bioconductor.org/packages/release/bioc/html/edgeR.html) <br>
