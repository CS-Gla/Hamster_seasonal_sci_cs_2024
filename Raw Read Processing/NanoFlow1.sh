### Demultiplexing, basecalling
for dir in RawSeqData/*/
do
dir1=${dir%*/}       # remove the trailing "/"
base1=${dir1##*/}    # print everything after the final "/" >>>> This is the run number
~/ont-guppy/bin/guppy_basecaller -i RawSeqData/${base1}/fast5/ -s RawSeqData/${base1}/ --flowcell FLO-MIN106 --kit SQK-PCB109 --barcode_kits SQK-PCB109 --trim_barcodes -x "cuda:0"
	for bardir in RawSeqData/${base1}/pass/barcode*/
	do
	dir2=${bardir%*/}      # remove the trailing "/"
	base2=${dir2##*/}      # print everything after the final "/" >>>> This is the barcode number
	cat RawSeqData/${base1}/pass/${base2}/*.fastq > RawData/${base1}_${base2}.fastq
	done
done




### trimming, and filtering 
mkdir RawData/temp/
for infile in RawData/*.fastq
do
base=$(basename ${infile} .fastq)
porechop -i RawData/${base}.fastq -o RawData/temp/${base}.fastq --extra_end_trim 20 -t 22
filtlong --min_length 25 --target_bases 5000000000000 --mean_q_weight 9 RawData/temp/${base}.fastq > ./RawData/${base}.fastq
done
rm -r ./RawData/temp/
