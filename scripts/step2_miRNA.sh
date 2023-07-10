#!/bin/bash

source $msrg/scripts/msrg-set-env.sh
source msrg-set-input.sh $1


echo "Directory: $i"
echo "FASTQ file: $i.fastq"
echo "Organism: $organism"
echo "Adapter: $adapter"
echo "Cutoff: $cutoff"
echo "Window: $window"
echo "Reference Dir: $refdir"

#clean and preppare the environment
rm -rf $i\_miRNA;  
mkdir $i\_miRNA

# compute values
cd $i
ii=`head -n 13 summary | grep 'total_read' | awk '{print $3}'` ; 
jj=`head -n 13 summary | grep 'nogenome'  | awk '{print $3}'` ; 
kk=`expr $ii - $jj`;

echo "total_read - nogenome = $kk"

# create a soft link to the original fastq file 
# (during this step this softlink will be replaced with a local version of fastq file)
cd ../$i\_miRNA
ln -s ../$i/$i.fastq $i.fastq

bash   $bindir/process_smRNA.sh $i.fastq $adapter
bash   $bindir/ngs_smrna_pipeline.sh $i $organism
python $bindir/extract_sam_by_readseq_length.py $i.hairpin.sam 18 23 $i.hairpin.18.23.sam 
python $bindir/extract_sam_by_min_PM_max_NM.py $i.hairpin.18.23.sam 17 1 $i.hairpin.sam
perl   $bindir/get_read_count_from_sam.pl -r $kk -s $i.hairpin.sam  > $i.miRNA_count.xls

