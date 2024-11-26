
This repository contains code utitlised in the analysis of data for the publication BLANK. It was written to transform raw fast5 files produced by Oxford Nanopore Sequencing and produce quantifiable expression matrices.

NanoFlow1.sh and NanoFLow2.sh were ran on linux within conda. 

cDNA_DE.yml cotains conda environment details (Basecalling, filtering and quality assesment of nanopore reads was carried out within this environment). R file were ran within Rstudio.


The files included carry out the following functions;

NanoFLow1.sh: Basecall fast5 files to produce fastq files, trim and filter fastq files based on quality score and minimum length <br>
NanoFLow2.sh: Utilise minimap2 to align fastq files to a reference genome producing bam files, build expression matrix of sequencing using salmon <br>
NanoFlow_Report.Rmd: Utilises EdgeR to filter for lowly expressed transcripts, and identify differentially expressed transcripts. <br>

glmm.r: Used to build a gneral linear modle of Siberian hamster CRISPR data.


Installation;
•	Install miniconda (or other conda environment; https://docs.anaconda.com/anaconda/install/)
o	Build cDNA_DE environment (conda env create -f cDNA_DE.yml)
•	Install latest R version
•	Install Rstudio

Requirements; Guppy basecaller (https://community.nanoporetech.com/docs/prepare/library_prep_protocols/Guppy-protocol/v/gpb_2003_v1_revax_14dec2018/linux-guppy) (v.4.2.1)
Guppy basecaller (https://community.nanoporetech.com/docs/prepare/library_prep_protocols/Guppy-protocol/v/gpb_2003_v1_revax_14dec2018/linux-guppy) (v.4.2.1) <br>
Porechop (https://github.com/rrwick/Porechop) (v0.2.4)<br>
Filtlong (https://github.com/rrwick/Filtlong) (v0.2.0)<br>
Minimap2 (https://github.com/lh3/minimap2) (v2.19)<br>
Salmon (https://github.com/COMBINE-lab/salmon) (v0.14.2)<br>
EdgeR (https://bioconductor.org/packages/release/bioc/html/edgeR.html) (v3.24.3)<br>


Installation time estimated at under 15 minutes on a standard desktop.


To run software;
1.	Download either the demo data contained within this repository or the full data set at GEO accession GSE274003 (https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.ncbi.nlm.nih.gov%2Fgeo%2Fquery%2Facc.cgi%3Facc%3DGSE274003&data=05%7C02%7CCalum.Stewart.2%40glasgow.ac.uk%7C6f16f23f8f6f495b1f7108dcb6ca9d43%7C6e725c29763a4f5081f22e254f0133c8%7C1%7C0%7C638586228534881949%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=4kLa6FcHkS7rTHJP%2BIB5GPI6CmsFPGLtVuUzlq6DYK4%3D&reserved=0) Enter token ifcfccouftqvten
2.	Place data in a “Rawdata” sub directory and run nanoflow1 and nanoflow2 scripts (./Nanoflow1.sh followed by ./Nanoflow2.sh) – Expected output is a results folder containing salmon count files
3.	Run the NanoFLow_report.Rmd script in rstudio, within the same directory as the nanoflow scirpts. – expected output is an analysis folder containing expression matrices.
4.	Expression matrices may be used in further analysis (Biodare)

