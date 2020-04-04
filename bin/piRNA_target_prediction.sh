#!/bin/bash
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
DATABASE_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/database
# $1 is the database, e.g.,  $DATABASE_PATH/Culex-quinquefasciatus-Johannesburg_TRANSCRIPTS_CpipJ2.4.fa
# $2.fa is the piRNA sequence, e.g. $2 is Cuquin_green
if [ ! -f $1.linux_db ]; then lt_create_idx $1 ; fi;
t=`perl $INSTALLATION_PATH/total_len.pl $2.fa `
python $INSTALLATION_PATH/biopython_retrieve_portion_of_fasta.py $2.fa 0 8 $2_1to8.fa
water -asequence $2_1to8.fa  -bsequence $1 -gapopen 100 -gapextend 10 -outfile $2_water_transcript_1to8.sam  -aformat sam -sreverse_bsequence Y 
echo "Name,1to8_Position_From_3'_in_Reverse_Strand,1to8Query"> $2_water_transcript_1to8.csv
grep 'NM:i:0$'  $2_water_transcript_1to8.sam | grep '8M	'  | awk -F'	' '{ if ($2==16 && $4==1 && match($6,/[0-9]+H8M/) ) print $1","substr($6,1,index($6,"H")-1)","$10 }' >> $2_water_transcript_1to8.csv
python $INSTALLATION_PATH/biopython_retrieve_portion_of_fasta.py $2.fa 1 9 $2_2to9.fa
water -asequence $2_2to9.fa  -bsequence $1 -gapopen 100 -gapextend 10 -outfile $2_water_transcript_2to9.sam  -aformat sam -sreverse_bsequence Y 
echo "Name,2to9_Position_From_3'_in_Reverse_Strand,2to9Query"> $2_water_transcript_2to9.csv
grep 'NM:i:0$'  $2_water_transcript_2to9.sam | grep '8M	'  | awk -F'	' '{ if ($2==16 && $4==1 && match($6,/[0-9]+H8M/) ) print $1","substr($6,1,index($6,"H")-1)","$10 }' >> $2_water_transcript_2to9.csv
/bin/rm  $2_water_transcript_1to8.sam $2_water_transcript_2to9.sam
if [ -e tmp3.fa ]; then /bin/rm tmp3.fa; fi;
echo "Name,1to8_AlignedRegionLength,1to8_MisMatchNumber,1to8_PerfectMatchNumber,1to8_AlignedRegion"> tmp.csv
echo "Name,1to8_FlankingSequence"> seq.csv
for i in ` grep -v '^Name' $2_water_transcript_1to8.csv `
do
s=`echo $i | cut -d',' -f 1`
e=`echo $i | cut -d',' -f 2`
echo $s | lt_retrieve $1 > $s.fa
l=`perl $INSTALLATION_PATH/total_len.pl $s.fa`
f=`expr $l - $e`
b=`expr $f - $t`
if [ ! $b -gt  0 ]; then b=0 ; fi;
#echo $s  $l $b $f $t
python $INSTALLATION_PATH/biopython_retrieve_portion_of_fasta.py $s.fa  $b $f tmp.fa
cat tmp.fa >> tmp3.fa
m=`expr $f + 13`
if [ $m -gt $l ]; then m=`expr $l + 0`; fi;
n=`expr $b - 13`
if [ ! $n -gt  0 ]; then n=0 ; fi;
python $INSTALLATION_PATH/biopython_retrieve_portion_of_fasta.py $s.fa $n $m tmp2.fa
revseq -sequence tmp2.fa -outseq tmp.fa
k=`perl $INSTALLATION_PATH/convert_2_single_line_fasta.pl tmp.fa | tail -1 `
echo "$s,$k">> seq.csv
/bin/rm $s.fa tmp.fa  tmp2.fa 
done
revseq -sequence tmp3.fa -outseq tmp2.fa
water -asequence $2.fa  -bsequence tmp2.fa -gapopen 100 -gapextend 10 -outfile tmp.sam  -aformat sam  
grep -v '^@' tmp.sam  | awk -F'	' '{ if ($2==0 && !match($6,/H/) ) { print $1","substr($6,1,index($6,"M")-1)","substr($13,6)","$10 } else { if ($2==0) {  print $1","substr($6,index($6,"H")+1,index($6,"M")-index($6,"H")-1)","substr($13,6)","$10  }   }  }' | awk -F','  '{ print $1","$2","$3","$2-$3","$4}'    >> tmp.csv
python $INSTALLATION_PATH/merge_with_left_join.py tmp.csv seq.csv Name tmp2.csv; mv tmp2.csv tmp.csv
python $INSTALLATION_PATH/merge_with_left_join.py $2_water_transcript_1to8.csv tmp.csv Name tmp2.csv; mv tmp2.csv $2_water_transcript_1to8.csv
/bin/rm tmp.sam tmp2.fa tmp.csv seq.csv
if [ -e tmp3.fa ]; then /bin/rm tmp3.fa; fi;
echo "Name,2to9_AlignedRegionLength,2to9_MisMatchNumber,2to9_PerfectMatchNumber,2to9_AlignedRegion"> tmp.csv
echo "Name,2to9_FlankingSequence"> seq.csv
for i in ` grep -v '^Name' $2_water_transcript_2to9.csv `
do
s=`echo $i | cut -d',' -f 1`
e=`echo $i | cut -d',' -f 2`
echo $s | lt_retrieve $1 > $s.fa
l=`perl $INSTALLATION_PATH/total_len.pl $s.fa`
f=`expr $l - $e`
b=`expr $f - $t`
if [ ! $b -gt  0 ]; then b=0 ; fi;
#echo $s  $l $b $f $t
python $INSTALLATION_PATH/biopython_retrieve_portion_of_fasta.py $s.fa  $b $f tmp.fa
cat tmp.fa >> tmp3.fa
m=`expr $f + 13`
if [ $m -gt $l ]; then m=`expr $l + 0`; fi;
n=`expr $b - 13`
if [ ! $n -gt  0 ]; then n=0 ; fi;
python $INSTALLATION_PATH/biopython_retrieve_portion_of_fasta.py $s.fa $n $m tmp2.fa
revseq -sequence tmp2.fa -outseq tmp.fa
k=`perl $INSTALLATION_PATH/convert_2_single_line_fasta.pl tmp.fa | tail -1 `
echo "$s,$k">> seq.csv
/bin/rm $s.fa tmp.fa  tmp2.fa 
done
revseq -sequence tmp3.fa -outseq tmp2.fa
water -asequence $2.fa  -bsequence tmp2.fa -gapopen 100 -gapextend 10 -outfile tmp.sam  -aformat sam  
grep -v '^@' tmp.sam  | awk -F'	' '{ if ($2==0 && !match($6,/H/) ) { print $1","substr($6,1,index($6,"M")-1)","substr($13,6)","$10 } else { if ($2==0) {  print $1","substr($6,index($6,"H")+1,index($6,"M")-index($6,"H")-1)","substr($13,6)","$10  }   }  }' | awk -F','  '{ print $1","$2","$3","$2-$3","$4}'    >> tmp.csv
python $INSTALLATION_PATH/merge_with_left_join.py tmp.csv seq.csv Name tmp2.csv; mv tmp2.csv tmp.csv
python $INSTALLATION_PATH/merge_with_left_join.py $2_water_transcript_2to9.csv tmp.csv Name tmp2.csv; mv tmp2.csv $2_water_transcript_2to9.csv
/bin/rm tmp.sam tmp2.fa tmp.csv seq.csv
python $INSTALLATION_PATH/merge_with_outer.py $2_water_transcript_1to8.csv $2_water_transcript_2to9.csv Name tmp.csv; mv tmp.csv $2_water_transcript.csv
grep '^Name' $2_water_transcript.csv > tmp2.csv ; grep -v '^Name' $2_water_transcript.csv | sort -t',' -k 6 -b -n -r >> tmp2.csv; mv tmp2.csv $2_water_transcript.csv
/bin/rm tmp.sam tmp2.fa
if [ -e tmp3.fa ]; then /bin/rm tmp3.fa; fi;
