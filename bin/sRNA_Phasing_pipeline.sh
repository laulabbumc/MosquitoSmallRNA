#!/bin/bash

bowtie -f -v 0 -a  -S -k 100000 -m 100000 --strata --best -p 1 $refdir/ucsc_$2_genome  $1 $1.phasing.sam

bash $bindir/sam2bam.sh $1.phasing.sam $1.phasing.bam 
bash $bindir/bam2bed.sh $1.phasing.bam  $1.phasing.bed 

cut -f 4  $1.phasing.bed | sort | uniq -c | sort -nr  | awk '{print $2"\t"$1}' | sort -k 1  > $1.phasing.NumberOfhits.txt 
join -t'	' -1 4 -2 1 $1.phasing.bed $1.phasing.NumberOfhits.txt   -o 1.1,1.2,1.3,1.4,2.2,1.6 |  tr -s ':' '\t' | awk -F'	' '{print $1"\t"$2"\t"$3"\t"$5"\t"$6"\t"$7}' > $1.phasing.NumberOfhits.txt.tmp; mv $1.phasing.NumberOfhits.txt.tmp $1.phasing.bed 

python $bindir/piRNA_PingPong_5to5_SPECIES.py $1.phasing.bed  $1.pingpong_SPECIES.txt
python $bindir/piRNA_PingPong_5to5_READS.py $1.phasing.bed  $1.pingpong_READS.txt
python $bindir/piRNA_Phasing_5to5_SPECIES.py $1.phasing.bed  $1.5to5_SPECIES.txt
python $bindir/piRNA_Phasing_3to5_SPECIES.py $1.phasing.bed  $1.3to5_SPECIES.txt
python $bindir/piRNA_PingPong10_5to5_Count_READS.py $1.phasing.bed  $1.pingpong_ReadCounts.txt


i=`echo $1| sed -e s'/\..._..\.trim\.fastq\.uq\.polyn//'`
j=`awk -F'	' '{if ($1==10) print $2"\t"$3}'  $1.pingpong_ReadCounts.txt`
k=`cd ../$i ; bash $bindir/get_total_mapped_read_count_from_summary.sh` 
echo "Sample	TotalReads	PingPongReads $i	$k	$j" | tr ' ' '\n' > $1.pingpong.txt
