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


#Define value of the flag
# 0  for Wolbachia, 1 for virus and structure RNA, 2 for TE
export flag=1 
echo "Flag: $flag"

# Define step: TE, virus, structural_RNA, wolbachia
export step="structural_RNA"
echo "Step: $step"

#save current directory
#curdir=$(pwd)

#prepare reference file
#cd $refdir
#cp $organism\_structure_rna repeat_$organism
#cp repeat_$organism.structure repeat_$organism

#bash update_repbase.sh $organism
#cd $curdir

# Compute total mapped read count
kk=`cd $i; bash get_total_mapped_read_count_from_summary.sh ; cd ..` 
#echo "kk: $kk"

#get to virus directory and clean it
cd $i\_virus
rm -rf *.sam TE_virus.* TE_virus_peaks.txt SPLIT *@* z*

samfile=../$i\_miRNA/$i.hairpin.sam
echo "samfile: $samfile"
bash TE_virus_count_plot.sh $organism 3 $i.18_23 $i.24_35  $i $kk $kk $kk $samfile $samfile $samfile
cd ..

# Saving the output from transposon pipeline
mkdir -p $organism\_results/$organism\_sRNA_STRUCTURE
cd $i\_virus;  

grep '^Transposon' TE_virus.xls | sed -e 's/Transposon/STRUCTURE/' | awk '{print $0"\tTotal\tNumberOfPeaks\tAverageDistanceBetweenPeaks\tRatio"}'  > $i\_STRUCTURE.xls;

grep -v  '^Transposon' TE_virus.xls | awk '{print $0"\t"$7+$8}' > tmp1; 

cut -f 2,3,4 TE_virus_peaks.txt > tmp2; 
paste tmp1 tmp2  | sort -k 10 -b -n -r | awk -F' ' '{ printf "%s \t %d \t %.1f \t %.1f \t %.1f \t %.1f  \t %.1f \t %.1f \t %.1f \t %d \t %.1f \t %.2f \n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11, $12 ;  }' >> $i\_STRUCTURE.xls;  

cp TE_virus.pdf $i\_STRUCTURE.pdf; 
cp $i\_STRUCTURE.xls $i\_STRUCTURE.pdf ../$organism\_results/$organism\_sRNA_STRUCTURE 

python $bindir/extract_read_length_distribution_from_sam.py $i.rep.sam 18 35 $i.structureRNA_read_length_distribution.xls  

cd ..
