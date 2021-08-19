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
export flag=0 
echo "Flag: $flag"

#save current directory
curdir=$(pwd)

#prepare reference file
cd $refdir
cp Wolbachia.fa repeat_$organism

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

# Saving the output from Wolbachia step
mkdir -p $organism\_results/$organism\_sRNA_Wolbachia
cd $i\_virus;  


grep '^Transposon' TE_virus.xls | sed -e 's/Transposon/Wolbachia/' | awk '{print $0"\tTotal\tNumberOfPeaks\tAverageDistanceBetweenPeaks\tRatio"}'  > $i\_Wolbachia.xls; 

grep -v  '^Transposon' TE_virus.xls | awk '{print $0"\t"$7+$8}' > tmp1; 

cut -f 2,3,4 TE_virus_peaks.txt > tmp2; 
paste tmp1 tmp2  | sort -k 10 -b -n -r | awk -F' ' '{ printf "%s \t %d \t %.1f \t %.1f \t %.1f \t %.1f  \t %.1f \t %.1f \t %.1f \t %d \t %.1f \t %.2f \n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11, $12 ;  }' >> $i\_Wolbachia.xls;  
cp TE_virus.pdf $i\_Wolbachia.pdf; 

cp $i\_Wolbachia.xls $i\_Wolbachia.pdf ../$organism\_results/$organism\_sRNA_Wolbachia 

cd ..



mkdir -p $organism\_results/$organism\_sRNA_length_distributions
mkdir -p $organism\_results/$organism\_sRNA_genecentric
mkdir -p $organism\_results/$organism\_sRNA_bigwig
mkdir -p $organism\_results/$organism\_sRNA_genecentric_consolidated

# Go back to the main directory
cd $i

bash $bindir/sort_bed.sh $i.fastq.genome-v2-50.bed $i.fastq.genome-v2-50.sorted.bed 

bedToBigBed $i.fastq.genome-v2-50.sorted.bed $refdir/$organism\_chrome_size.txt $i.fastq.genome-v2-50.sorted.bb

grep -v 'RPM' $i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.xls | awk -F'        ' '{ if ($12>5) print $2}' | sed -e 's/:/-/' |  awk -F'-' '{if ($2>1) {print $1"\t"$2-1"\t"$3} else {print $1"\t0\t"$3 } }' |  intersectBed -v -a -  -b $refdir/$organism\_refseq.ucsc.bed > intergenic.$i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.bed ; 

cat intergenic.$i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.bed | awk -F'       ' '{ print $1":"$2+1"-"$3}' | fgrep -f - $i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.xls > intergenic.$i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.xls 

grep 'RPM' $i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.xls  | head -n 1 > tmp; 
cat  intergenic.$i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.xls  >> tmp; 
mv tmp intergenic.$i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.xls ;

cp $i.length.count.xls  genecentric_$i.fastq-25-0.02.collapsed.xls  intergenic.$i.fastq.genome-v2-50-coverage-w25-0.02-collapsed.xls  ../$organism\_results/$organism\_sRNA_genecentric;  
cd ..

#In miRNA directory
cd $i\_miRNA ; 
head -n 1 $i.miRNA_count.xls > $i.miRNA.xls ;  
bash $bindir/extract_miRNA.sh $refdir/hairpin_$organism.0.7_ids.txt $i.miRNA_count.xls | sort -k 3 -b -n -r >> $i.miRNA.xls ; 

cp $i.miRNA.xls ../$organism\_results/$organism\_sRNA_length_distributions ; 
cd .. ;

#In Main directory
cd $i;  
wigToBigWig -clip  $i.fastq-nor-ngtv-25-0.02.wig $refdir/$organism\_chrome_size.txt $i.nor-ngtv.bw; 
cp $i.nor-ngtv.bw ../$organism\_results/$organism\_sRNA_bigwig; 

wigToBigWig -clip  $i.fastq-nor-pstv-25-0.02.wig $refdir/$organism\_chrome_size.txt $i.nor-pstv.bw
cp $i.nor-pstv.bw ../$organism\_results/$organism\_sRNA_bigwig;

wigToBigWig -clip  $i.fastq-unq-ngtv-25-0.02.wig $refdir/$organism\_chrome_size.txt $i.unq-ngtv.bw
cp $i.unq-ngtv.bw ../$organism\_results/$organism\_sRNA_bigwig;

wigToBigWig -clip  $i.fastq-unq-pstv-25-0.02.wig $refdir/$organism\_chrome_size.txt $i.unq-pstv.bw
cp $i.unq-pstv.bw ../$organism\_results/$organism\_sRNA_bigwig;

cp $i.unq*.bw ../$organism\_results/$\organism\_sRNA_bigwig;

bash $bindir/consolidate_genecentric.sh $i  ../$organism\_results/$organism\_sRNA_genecentric_consolidated; 
cd ..


