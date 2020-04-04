#!/bin/bash 
# $1 is $1 is  AnGam_Fcarc_TN
# $2 is ../gene_centric_test/summary
# $3 is Angam
# $4 is the adaptor sequence, e.g., AGATCGGAAG
#INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin/
#i=`head -n 13 $2 | grep 'total_read' | awk '{print $3}'` ; j=`head -n 13 $2 | grep 'nogenome'  | awk '{print $3}'` ; k=`expr $i - $j`
#bash /projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin/miRNA_pipeline.sh $1  $2  $3  $4
#ln -s $1_trim.fastq.uq $1.trim.fastq.uq.polyn
#bash $INSTALLATION_PATH/dust_prinseq_local.sh $1.trim.fastq.uq.polyn
#perl $INSTALLATION_PATH/extract_fasta_sequence_given_len_range.pl $1.trim.fastq.uq.polyn 18 23  $1.18_23.trim.fastq.uq.polyn
#perl $INSTALLATION_PATH/extract_fasta_sequence_given_len_range.pl $1.trim.fastq.uq.polyn 24 35  $1.24_35.trim.fastq.uq.polyn
#bash $INSTALLATION_PATH/TE_virus_count_plot.sh $3 3 $1.18_23 $1.24_35  $1 $k $k $k $1.hairpin.sam  $1.hairpin.sam  $1.hairpin.sam
grep '^Transposon' TE_virus.xls | sed -e 's/Transposon/TRANSPOSON/' | awk '{print $0"\tTotal\tNumberOfPeaks\tAverageDistanceBetweenPeaks\tRatio"}'  > $1\_TRANSPOSON.xls; grep -v  '^Transposon' TE_virus.xls | awk '{print $0"\t"$7+$8}' > tmp1; cut -f 2,3,4 TE_virus_peaks.txt > tmp2; paste tmp1 tmp2  | sort -k 10 -b -n -r | awk -F'	' '{ printf "%s \t %d \t %.1f \t %.1f \t %.1f \t %.1f  \t %.1f \t %.1f \t %.1f \t %d \t %.1f \t %.2f \n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11, $12 ;  }' >> $1\_TRANSPOSON.xls;  cp TE_virus.pdf $1\_TRANSPOSON.pdf; 
