#!/bin/bash 
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
DATABASE_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/database
#input argument
#$1 fastq file
#$2 transcript file, e.g Angam_transcript_TE_virus.fa
prefix=${1%.fa*}
bash $INSTALLATION_PATH/piRNA_target_prediction.sh $2   $prefix
bash $INSTALLATION_PATH/extract_water_alignment.sh   $prefix
