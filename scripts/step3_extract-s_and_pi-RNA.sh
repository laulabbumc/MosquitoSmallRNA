#!/bin/bash -l

source $msrg/scripts/msrg-set-env.sh
source msrg-set-input.sh $1


echo "Directory: $i"
echo "FASTQ file: $i.fastq"
echo "Organism: $organism"
echo "Linker: $linker"
echo "Cutoff: $cutoff"
echo "Window: $window"
echo "Reference Dir: $refdir"

#prepare the environment
rm -rf $i\_virus;  
mkdir $i\_virus


# create a soft link to the original *.trim.fastq.uq.polyn file 
cd $i\_virus
ln -s ../$i/$i.trim.fastq.uq.polyn $i.trim.fastq.uq.polyn

bash $bindir/dust_prinseq_local.sh  $i.trim.fastq.uq.polyn
perl $bindir/extract_fasta_sequence_given_len_range.pl $i.trim.fastq.uq.polyn 18 23  $i.18_23.trim.fastq.uq.polyn
perl $bindir/extract_fasta_sequence_given_len_range.pl $i.trim.fastq.uq.polyn 24 35  $i.24_35.trim.fastq.uq.polyn

