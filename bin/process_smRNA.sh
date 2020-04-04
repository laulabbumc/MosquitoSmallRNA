#!/bin/bash
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
infile=$1
prefix=${1%.fastq*}

#adapter="AGATCGGAAGAGCAC"

cutadapt -a $2 -e 0.2   -o  $prefix"_trim.fastq"    $1

trim_lib=$prefix"_trim.fastq"

bash $INSTALLATION_PATH/ngs_single_end_pre_mapping_qc.sh $trim_lib 
uqfile=$trim_lib".uq"

clipped_file=$prefix".clipped.uq"
noclipped_file=$prefix".noclipped.uq"

cp $uqfile $noclipped_file
touch $clipped_file
