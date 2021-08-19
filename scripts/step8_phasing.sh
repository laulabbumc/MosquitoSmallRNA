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

mkdir -p $organism\_results/$organism\_sRNA_Phasing
mkdir -p $organism\_results/$organism\_sRNA_length_distributions

# In miRNA directory
cd $i\_miRNA;  
python $bindir/extract_read_length_distribution_from_sam.py $i.hairpin.sam 18 35 $i.miRNA_read_length_distribution.xls ; 

cd .. 

# Back to the top level
grep -i -v 'length' $i/$i.length.count.xls > $i/$i.length_distribution.txt; 

python $bindir/combine_all_miRNA_TE_Virus_structureRNA.py  $i/$i.length_distribution.txt $i\_miRNA/$i.miRNA_read_length_distribution.xls $i\_virus/$i.TE_read_length_distribution.xls $i\_virus/$i.Virus_read_length_distribution.xls $i\_virus/$i.structureRNA_read_length_distribution.xls $i/$i.length.all.xls; 
cp $i/$i.length.all.xls $organism\_results/$organism\_sRNA_length_distributions


# In Virus directory
# Make a soft link to the original fastq file
cd $i\_virus
ln -s ../$i/$i.fastq $i.fastq

bash $bindir/sRNA_Phasing_pipeline.sh $i.24_35.trim.fastq.uq.polyn $organism


echo "Position  Value" > Phasing_header.txt; 
cat Phasing_header.txt $i.24_35.trim.fastq.uq.polyn.3to5_SPECIES.txt   > ../$organism\_results/$organism\_sRNA_Phasing/$i.24_35.trim.fastq.uq.polyn.3to5_SPECIES.xls

echo "Position  Value" > Phasing_header.txt; 
cat Phasing_header.txt $i.24_35.trim.fastq.uq.polyn.5to5_SPECIES.txt   > ../$organism\_results/$organism\_sRNA_Phasing/$i.24_35.trim.fastq.uq.polyn.5to5_SPECIES.xls 

echo "Position  Value" > Phasing_header.txt; 
cat Phasing_header.txt $i.24_35.trim.fastq.uq.polyn.pingpong_SPECIES.txt   > ../$organism\_results/$organism\_sRNA_Phasing/$i.24_35.trim.fastq.uq.polyn.pingpong_SPECIES.xls

echo "Position  Value" > Phasing_header.txt; 
cat Phasing_header.txt $i.24_35.trim.fastq.uq.polyn.pingpong_READS.txt   > ../$organism\_results/$organism\_sRNA_Phasing/$i.24_35.trim.fastq.uq.polyn.pingpong_READS.xls

bash $bindir/siRNA_Phasing_pipeline.sh $i.18_23.trim.fastq.uq.polyn $organism


echo "Position  Value" > Phasing_header.txt; 
cat Phasing_header.txt $i.18_23.trim.fastq.uq.polyn.siRNA.5to5_SPECIES.txt   > ../$organism\_results/$organism\_sRNA_Phasing/$i.18_23.trim.fastq.uq.polyn.siRNA.5to5_SPECIES.txt

echo "Position  Value" > Phasing_header.txt; 
cat Phasing_header.txt $i.18_23.trim.fastq.uq.polyn.siRNA.3to5_SPECIES.txt   > ../$organism\_results/$organism\_sRNA_Phasing/$i.18_23.trim.fastq.uq.polyn.siRNA.3to5_SPECIES.txt

echo "Position  Value" > Phasing_header.txt; 
cat Phasing_header.txt $i.18_23.trim.fastq.uq.polyn.siRNA.5to5.pingpong_SPECIES.txt   > ../$organism\_results/$organism\_sRNA_Phasing/$i.18_23.trim.fastq.uq.polyn.siRNA.5to5.pingpong_SPECIES.txt  ;  
cd ..
