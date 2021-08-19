#!/bin/sh

#katia: this should not be necessary
#export PATH=/projectnb/lau-bumc/katia/bin:$PATH

# Path to the reference file
#katia
#ref=/projectnb/lau-bumc/gdayama/projects/yamashita_Dmel_github_test/reference/

# Copy it to current directory
# katia
#cp $ref/repeat_$1.TE ./repeat_$1


lt_create_idx repeat_$1
formatdb -i repeat_$1 -p F -o T
bowtie-build repeat_$1 repeat_$1

#cp repeat_Aeaeg_all repeat_Aeaeg
#lt_create_idx repeat_Aeaeg -q
#formatdb -i repeat_Aeaeg -p F -o T
#bowtie-build repeat_Aeaeg repeat_Aeaeg


#cp repeat_Angam_all repeat_Angam
#lt_create_idx repeat_Angam -q
#formatdb -i repeat_Angam -p F -o T
#bowtie-build repeat_Angam repeat_Angam
#cp repeat_Aealb_all repeat_Aealb

#lt_create_idx repeat_Aealb -q
#formatdb -i repeat_Aealb -p F -o T
#bowtie-build repeat_Aealb repeat_Aealb
#cp repeat_Cuquin_all repeat_Cuquin

#lt_create_idx repeat_Cuquin -q
#formatdb -i repeat_Cuquin -p F -o T
#bowtie-build repeat_Cuquin repeat_Cuquin

#cp repeat_Anstep_all repeat_Anstep
#lt_create_idx repeat_Anstep -q
#formatdb -i repeat_Anstep -p F -o T
#bowtie-build repeat_Anstep repeat_Anstep


exit
