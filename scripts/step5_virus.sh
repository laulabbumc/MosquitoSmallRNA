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


#Define value of the flag
# 0  for Wolbachia, 1 for virus and structure RNA, 2 for TE
export flag=1 
echo "Flag: $flag"

#save current directory
curdir=$(pwd)

#prepare reference file
cd $refdir
cp $organism\_virus repeat_$organism

bash update_repbase.sh $organism
cd $curdir

# Compute total mapped read count
kk=`cd $i; bash get_total_mapped_read_count_from_summary.sh ; cd ..` 
echo "kk: $kk"

#get to virus directory and clean it
cd $i\_virus
rm -rf *.sam TE_virus.* TE_virus_peaks.txt SPLIT *@* z*

samfile=../$i\_miRNA/$i.hairpin.sam
echo "samfile: $samfile"
bash TE_virus_count_plot.sh $organism 3 $i.18_23 $i.24_35  $i $kk $kk $kk $samfile $samfile $samfile
cd ..

# Saving the output from transposon pipeline
mkdir -p $organism\_results/$organism\_sRNA_VIRUS
cd $i\_virus;  

grep '^Transposon' TE_virus.xls | sed -e 's/Transposon/VIRUS/' | awk '{print $0"\tTotal\tNumberOfPeaks\tAverageDistanceBetweenPeaks\tRatio"}'  > $i\_VIRUS.xls; 
grep -v  '^Transposon' TE_virus.xls | awk '{print $0"\t"$7+$8}' > tmp1; 
cut -f 2,3,4 TE_virus_peaks.txt > tmp2; 
paste tmp1 tmp2  | sort -k 10 -b -n -r | awk -F' ' '{ printf "%s \t %d \t %.1f \t %.1f \t %.1f \t %.1f  \t %.1f \t %.1f \t %.1f \t %d \t %.1f \t %.2f \n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11, $12 ;  }' >> $i\_VIRUS.xls;  
cp TE_virus.pdf $i\_VIRUS.pdf;

cp $i\_VIRUS.xls $i\_VIRUS.pdf ../$organism\_results/$organism\_sRNA_VIRUS ; 

python $bindir/extract_read_length_distribution_from_sam.py $i.rep.sam 18 35 $i.Virus_read_length_distribution.xls ; 
cd ..
