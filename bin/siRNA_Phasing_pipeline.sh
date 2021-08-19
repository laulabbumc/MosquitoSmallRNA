#!/bin/bash

bowtie -f -v 0 -a  -S -k 100000 -m 100000 --strata --best -p 1 $refdir/ucsc_$2_genome  $1 $1.siRNA_phasing.sam
bash $bindir/sam2bam.sh $1.siRNA_phasing.sam $1.siRNA_phasing.bam 
bash $bindir/bam2bed.sh $1.siRNA_phasing.bam  $1.siRNA_phasing.bed 
cut -f 4  $1.siRNA_phasing.bed | sort | uniq -c | sort -nr  | awk '{print $2"\t"$1}' | sort -k 1  > $1.siRNA_phasing.NumberOfhits.txt 
join -t'	' -1 4 -2 1 $1.siRNA_phasing.bed $1.siRNA_phasing.NumberOfhits.txt   -o 1.1,1.2,1.3,1.4,2.2,1.6 |  tr -s ':' '\t' | awk -F'	' '{print $1"\t"$2"\t"$3"\t"$5"\t"$6"\t"$7}' > $1.siRNA_phasing.NumberOfhits.txt.tmp; mv $1.siRNA_phasing.NumberOfhits.txt.tmp $1.siRNA_phasing.bed 
time python $bindir/siRNA_Phasing_5to5_SPECIES.py $1.siRNA_phasing.bed  $1.siRNA.5to5_SPECIES.txt
time python $bindir/siRNA_Phasing_3to5_SPECIES.py $1.siRNA_phasing.bed  $1.siRNA.3to5_SPECIES.txt
time python $bindir/siRNA_PingPong_5to5_SPECIES.py $1.siRNA_phasing.bed  $1.siRNA.5to5.pingpong_SPECIES.txt
