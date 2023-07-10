#!/bin/bash

source $msrg/scripts/msrg-set-env.sh
source msrg-set-input.sh $1

echo "Directory: $i"
echo "FASTQ file: $i.fastq"
echo "Organism: $organism"
echo "Adapter: $adapter"
echo "Cutoff: $cutoff"
echo "Window: $window"
echo "Bin Dir: $bindir"
echo "Reference Dir: $refdir"

# Note: i - value from a sample file (input directory name)

#Define value of the flag
# 0  for Wolbachia, 1 for virus and structure RNA, 2 for TE
export flag=2 

# Define step: TE, virus, structural_RNA, wolbachia
export step="TE"

echo "Flag: $flag"
echo "Step: $step"

#save current directory
#curdir=$(pwd)

#prepare reference file
#cd $refdir
#cp $refdir/repeat_$organism $organism\_$step

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
mkdir -p $organism\_results/$organism\_sRNA_TRANSPOSON
cd $i\_virus;  

grep '^Transposon' TE_virus.xls | sed -e 's/Transposon/TRANSPOSON/' | awk '{print $0"\tTotal\tNumberOfPeaks\tAverageDistanceBetweenPeaks\tRatio"}'  > $i\_TRANSPOSON.xls; 

grep -v  '^Transposon' TE_virus.xls | awk '{print $0"\t"$7+$8}' > tmp1; 
cut -f 2,3,4 TE_virus_peaks.txt > tmp2; 

paste tmp1 tmp2  | sort -k 10 -b -n -r | awk -F'     ' '{ printf "%s \t %d \t %.1f \t %.1f \t %.1f \t %.1f  \t %.1f \t %.1f \t %.1f \t %d \t %.1f \t %.2f \n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11, $12 ;  }' >> $i\_TRANSPOSON.xls;  

cp TE_virus.pdf $i\_TRANSPOSON.pdf; 
cp $i\_TRANSPOSON.xls $i\_TRANSPOSON.pdf ../$organism\_results/$organism\_sRNA_TRANSPOSON 

python $bindir/extract_read_length_distribution_from_sam.py $i.rep.sam 18 35 $i.TE_read_length_distribution.xls ;
cd .. ;   

