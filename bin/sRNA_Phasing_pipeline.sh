#!/bin/bash
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
DATABASE_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/database
# $1 is the sample name, e.g. AnGam_Fcarc_TN.fastq 
# $2 is the organism name, e.g. Angam 
# $3 is the adapter sequence
prefix=${1%.fastq*}
cutadapt -a $3  -e 0.1 $1 -o $prefix.cutadapt.fastq
bash $INSTALLATION_PATH/create_uq_from_fastq.sh  $prefix.cutadapt.fastq
mv $prefix.cutadapt.fastq.uq  $1.uq
bash $INSTALLATION_PATH/dust_prinseq_local.sh $1.uq
perl $INSTALLATION_PATH/extract_fasta_sequence_given_len_range.pl $1.uq 24 35  $1.24_35.uq
bowtie -f -v 0 -a  -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/ucsc_$2_genome  $1.24_35.uq $1.phasing.sam
bash $INSTALLATION_PATH/sam2bam.sh $1.phasing.sam $1.phasing.bam 
bash $INSTALLATION_PATH/bam2bed.sh $1.phasing.bam  $1.phasing.bed 
cut -f 4  $1.phasing.bed | sort | uniq -c | sort -nr  | awk '{print $2"\t"$1}' | sort -k 1  > $1.phasing.NumberOfhits.txt 
join -t'	' -1 4 -2 1 $1.phasing.bed $1.phasing.NumberOfhits.txt   -o 1.1,1.2,1.3,1.4,2.2,1.6 |  tr -s ':' '\t' | awk -F'	' '{print $1"\t"$2"\t"$3"\t"$5"\t"$6"\t"$7}' > tmp; mv tmp $1.phasing.bed 
python $INSTALLATION_PATH/piRNA_PingPong_5to5_SPECIES.py $1.phasing.bed  $1.pingpong_SPECIES.txt
python $INSTALLATION_PATH/piRNA_PingPong_5to5_READS.py $1.phasing.bed  $1.pingpong_READS.txt
python $INSTALLATION_PATH/piRNA_Phasing_5to5_SPECIES.py $1.phasing.bed  $1.5to5_SPECIES.txt
python $INSTALLATION_PATH/piRNA_Phasing_3to5_SPECIES.py $1.phasing.bed  $1.3to5_SPECIES.txt
