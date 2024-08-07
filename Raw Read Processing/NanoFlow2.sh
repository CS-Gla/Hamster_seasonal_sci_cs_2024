### Main loop ###
### index ref
minimap2 -t 22 -I 1000G -d ./ReferenceData/transcript.mmi ./ReferenceData/transcript.fna

mkdir Analysis/
mkdir Analysis/Minimap/
mkdir Analysis/samtools/
mkdir Analysis/Salmon/
mkdir Analysis/Results/

for infile in ./RawData/*.fastq
do
base=$(basename ${infile} .fastq)
# align to ref
minimap2 -t 22 -ax map-ont -p 1.0 -N 100 ./ReferenceData/transcript.mmi ${infile} | samtools view -Sb > ./Analysis/Minimap/raw${base}.bam
# sort alignments
samtools sort ./Analysis/Minimap/raw${base}.bam -o ./Analysis/Minimap/${base}.bam -@ 22
rm ./Analysis/Minimap/raw${base}.bam
# index alignments
samtools index ./Analysis/Minimap/${base}.bam
# some useful stats
samtools flagstat ./Analysis/Minimap/${base}.bam > ./Analysis/samtools/${base}.flagstat
# count reads
salmon quant --noErrorModel -p 22 -t ./ReferenceData/transcript.fna -g ./ReferenceData/annotation.gff -l SF -a ./Analysis/Minimap/${base}.bam -o ./Analysis/Salmon/${base}
done

# QC report scipt
R --slave -e 'rmarkdown::render("NanoFlow_QC_Report.Rmd", "html_document")'

# analysis scripts....the report ones stopped working when called from the commandline for some reason!!!
# Still work if you load them in R studio, set WD, then knit.
#R --slave -e 'rmarkdown::render("NanoFlow_Report_NoIso.Rmd", "html_document")'
#R --slave -e 'rmarkdown::render("NanoFlow_Report.Rmd", "html_document")'
