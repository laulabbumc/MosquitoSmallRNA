#!/bin/bash
# require the following program in $PATH
# 1) cutadapt
# 2) fastx_clipper
# 3) bowtie
# 4) samtools
# 5) bamToBed
# 6) intersectBed
# 7) lt_create_idx
# 8) seq_stat
# 9) ngs_coverage-nelson
# 10) ngs_genecentric


INSTALLATION_PATH=$bindir
DATABASE_PATH=$refdir


# $DATABASE_PATH/$2_virus is the virus database
# $DATABASE_PATH/hairpin_$2 is the miRNA database
# $DATABASE_PATH/ucsc_$2_genome is the genome file
# $DATABASE_PATH/$2_structurerna.bed is the structure RNA bed file
# $DATABASE_PATH/repeat_$2 is the repeat database
# $DATABASE_PATH/$2_refseq.bed is the genome bed file


#input argument
#$1 fastq file
#$2 organism name, for example fly
#$3 linker
#$4 jackpot_cutoff
#$5 extend_window


mismatch0=0
mismatch1=1
mismatch2=2
mismatch3=3
plot_window_size=25
extend_window=$5
cutoff=0.02

prefix=${1%.fastq*}



echo " ngs_genecentric -r $DATABASE_PATH/$2_refseq.bed -e $extend_window -v $1.genome-v2-50-coverage-w$plot_window_size-$cutoff -m $1.genome-v2-50.bed -o genecentric_$1-$plot_window_size-$cutoff.xls -n $nomorized_count  "
$INSTALLATION_PATH/ngs_genecentric -r $DATABASE_PATH/$2_refseq.bed -e $extend_window -v $1.genome-v2-50-coverage-w$plot_window_size-$cutoff -m $1.genome-v2-50.bed -o genecentric_$1-$plot_window_size-$cutoff.xls -n $nomorized_count 
perl  $INSTALLATION_PATH/collapse_isoforms.pl genecentric_$1-$plot_window_size-0.02.xls  >  genecentric_$1-$plot_window_size-0.02.collapsed.xls
exit
