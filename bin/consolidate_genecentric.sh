#!/bin/bash

# $1.fastq-25-0.02 is sample name, e.g., AeAlbo_Fcarc_OA
# $2 is the results directory, e.g.  ~/AeAlbo_results/AeAlbo_experiment_20181221_genecentric_consolidated 

 grep -v '^Gene'   genecentric_$1.fastq-25-0.02.collapsed.xls  | awk -F'	' '{ if ($5>1) { print $3"\t"$5-1"\t"$6"\t"$1"\t"$24"\t"$4; } else { print $3"\t0\t"$6"\t"$1"\t"$24"\t"$4;  }}' > genecentric_$1.fastq-25-0.02.collapsed.bed   ; 

  bash sort_bed.sh  genecentric_$1.fastq-25-0.02.collapsed.bed  genecentric_$1.fastq-25-0.02.collapsed.sorted.bed  ;  

 mergeBed -d 0 -c 4,5 -o first,distinct_sort_num_desc  -i  genecentric_$1.fastq-25-0.02.collapsed.sorted.bed | sed -e 's/	/-/' | sed -e 's/	/-/' | sort -k 1  > genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.NorLocus.bed ; 

 grep -v '^Gene'   genecentric_$1.fastq-25-0.02.collapsed.xls  | awk -F'	' '{ if ($5>1) { print $3"\t"$5-1"\t"$6"\t"$1"="$24; } else { print $3"\t0\t"$6"\t"$1"="$24;  }}' > genecentric_$1.fastq-25-0.02.collapsed.bed   ;  

  bash sort_bed.sh  genecentric_$1.fastq-25-0.02.collapsed.bed  genecentric_$1.fastq-25-0.02.collapsed.sorted.bed  ; 

 mergeBed -d 0 -c 4 -o distinct -i  genecentric_$1.fastq-25-0.02.collapsed.sorted.bed | sed -e 's/	/-/' | sed -e 's/	/-/' | sort -k 1  > genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.bed ;  

rm genecentric_$1.fastq-25-0.02.collapsed.sorted.max.bed ; 
cut -f 2  genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.bed > tmp0 ; 

for j in `cat tmp0`; do echo $j > tmp ; cat tmp | tr ',' '\n'  | sed -e 's/=/	/g' | sort -k 2 -b -n -r | head -n 1 | cut -f 1  > tmp2 ; paste tmp tmp2  >> genecentric_$1.fastq-25-0.02.collapsed.sorted.max.bed  ; done 

sort -k 2 genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.bed > tmp; 
mv tmp genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.bed ;  
sort -k 1 genecentric_$1.fastq-25-0.02.collapsed.sorted.max.bed > tmp2 ; 
mv tmp2 genecentric_$1.fastq-25-0.02.collapsed.sorted.max.bed; 
join -t'	' -1 2 -2 1 genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.bed genecentric_$1.fastq-25-0.02.collapsed.sorted.max.bed | sort -k 3 > tmp0; 
mv tmp0 genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.bed   

echo "Consolidated_Annotated_region	Gene_and_Nor_Locus	Gene" > genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.txt; 
cat genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.bed >> genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.txt    
sort -k 3 genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.txt > genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.sorted.txt 
sort -k 1 genecentric_$1.fastq-25-0.02.collapsed.xls > genecentric_$1.fastq-25-0.02.collapsed.sorted.xls

join -t'	' -1 3 -2 1 genecentric_$1.fastq-25-0.02.collapsed.sorted.merged.sorted.txt genecentric_$1.fastq-25-0.02.collapsed.sorted.xls > genecentric_$1.fastq-25-0.02.consolidated.xls
grep '^Gene' genecentric_$1.fastq-25-0.02.consolidated.xls > tmp
grep -v '^Gene' genecentric_$1.fastq-25-0.02.consolidated.xls | sort -k 26 -b -n -r >> tmp
mv tmp genecentric_$1.fastq-25-0.02.consolidated.xls
cp genecentric_$1.fastq-25-0.02.consolidated.xls $2
