#!/bin/bash -l

source $msrg/scripts/msrg-set-env.sh
source msrg-set-input.sh $1

echo "Directory: $i"
echo "FASTQ file: $i.fastq"
echo "Organism: $organism"
echo "Adapter: $adapter"
echo "Cutoff: $cutoff"
echo "Window: $window"
echo "Reference Dir: $refdir"


# Note: i - value from a sample file (input directory name)
cd $i

#Start gene-centric script
$bindir/gene-centric.sh $i.fastq $organism $adapter $cutoff $window


# compute reads length distribution from a fastq file
echo -e "Length\t$i" > $i.length.count.xls  
awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {printf "%d\t%d\n", l, lengths[l];}}'  $i.cutadapt.fastq  | sort -k 1 -b -n >> $i.length.count.xls

cd ..
