#!/bin/bash
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
# $1 is sample name, e.g. Angam_green
grep -v '^Name' $1_water_transcript.csv | egrep -i -v '^virus|^TE' | cut -d',' -f 1-8 > $1_transcript.csv
grep -v '^Name' $1_water_transcript.csv | egrep -i -v '^virus|^TE' |  cut -d',' -f 1,9,10,11,12,13,14,15  >> $1_transcript.csv
sort -t',' -k 6 -b -n -r $1_transcript.csv > tmp; mv tmp $1_transcript.csv
for (( i=1; i<=8; i++ ))
do
  sed -n ${i}p  $1_transcript.csv | awk -F',' '{print ">"$1"\n"$8}' > transcript.fa
  revseq -sequence transcript.fa -outseq transcript_rc.fa -noreverse
  water -asequence $1.fa -bsequence transcript.fa -gapopen 100 -gapextend 10 -outfile transcript.water 
  grep -v '^>' $1.fa | sed -e "s/^/             5\'-/" | sed -e "s/$/-3\'/" >> transcript.aln
  tail -7 transcript.water | head -n 1 | awk '{print $3}'  > transcript_alignment.aln
  tail -7 transcript.water | head -n 2 | tail -1  | sed -e 's/ //g' | awk '{print $0}'  >> transcript_alignment.aln
  tail -7 transcript.water | head -n 3 | tail -1  |  awk '{print $3}' >>   transcript_alignment.aln
  python $INSTALLATION_PATH/rewrite_water_alignment.py transcript_alignment.aln | sed -e 's/^/                /'>> transcript.aln
  echo ">query" > query.fa
  tail -1 transcript.aln | sed -e 's/ //g' >> query.fa
    revseq -sequence query.fa -outseq query_rc.fa -noreverse
  grep -v '^>' query_rc.fa | sed -e 's/^/                /'>> transcript.aln
  grep -v '^>' transcript_rc.fa   | sed -e "s/^/3\'-/" | sed -e "s/$/-5\'/" >> transcript.aln
  grep '^>' transcript.fa | sed -e 's/>//'  >> transcript.aln
  echo "" >> transcript.aln
done
grep -v '^Name' $1_water_transcript.csv | egrep -i '^TE' | cut -d',' -f 1-8 > $1_transcript.csv
grep -v '^Name' $1_water_transcript.csv | egrep -i '^TE' |  cut -d',' -f 1,9,10,11,12,13,14,15  >> $1_transcript.csv
sort -t',' -k 6 -b -n -r $1_transcript.csv > tmp; mv tmp $1_transcript.csv
for (( i=1; i<=2; i++ ))
do
  sed -n ${i}p  $1_transcript.csv | awk -F',' '{print ">"$1"\n"$8}' > transcript.fa
  revseq -sequence transcript.fa -outseq transcript_rc.fa -noreverse
  water -asequence $1.fa -bsequence transcript.fa -gapopen 100 -gapextend 10 -outfile transcript.water 
  grep -v '^>' $1.fa | sed -e "s/^/             5\'-/" | sed -e "s/$/-3\'/" >> transcript.aln
  tail -7 transcript.water | head -n 1 | awk '{print $3}'  > transcript_alignment.aln
  tail -7 transcript.water | head -n 2 | tail -1  | sed -e 's/ //g' | awk '{print $0}'  >> transcript_alignment.aln
  tail -7 transcript.water | head -n 3 | tail -1  |  awk '{print $3}' >>   transcript_alignment.aln
  python $INSTALLATION_PATH/rewrite_water_alignment.py transcript_alignment.aln | sed -e 's/^/                /'>> transcript.aln
  echo ">query" > query.fa
  tail -1 transcript.aln | sed -e 's/ //g' >> query.fa
   revseq -sequence query.fa -outseq query_rc.fa -noreverse
  grep -v '^>' query_rc.fa | sed -e 's/^/                /'>> transcript.aln
  grep -v '^>' transcript_rc.fa   | sed -e "s/^/3\'-/" | sed -e "s/$/-5\'/" >> transcript.aln
  grep '^>' transcript.fa | sed -e 's/>//'  >> transcript.aln
  echo "" >> transcript.aln
done
grep -v '^Name' $1_water_transcript.csv | egrep -i '^virus' | cut -d',' -f 1-8 > $1_transcript.csv
grep -v '^Name' $1_water_transcript.csv | egrep -i '^virus' |  cut -d',' -f 1,9,10,11,12,13,14,15  >> $1_transcript.csv
sort -t',' -k 6 -b -n -r $1_transcript.csv > tmp; mv tmp $1_transcript.csv
for (( i=1; i<=3; i++ ))
do
  sed -n ${i}p  $1_transcript.csv | awk -F',' '{print ">"$1"\n"$8}' > transcript.fa
  revseq -sequence transcript.fa -outseq transcript_rc.fa -noreverse
  water -asequence $1.fa -bsequence transcript.fa -gapopen 100 -gapextend 10 -outfile transcript.water 
  grep -v '^>' $1.fa | sed -e "s/^/             5\'-/" | sed -e "s/$/-3\'/" >> transcript.aln
  tail -7 transcript.water | head -n 1 | awk '{print $3}'  > transcript_alignment.aln
  tail -7 transcript.water | head -n 2 | tail -1  | sed -e 's/ //g' | awk '{print $0}'  >> transcript_alignment.aln
  tail -7 transcript.water | head -n 3 | tail -1  |  awk '{print $3}' >>   transcript_alignment.aln
  python $INSTALLATION_PATH/rewrite_water_alignment.py transcript_alignment.aln | sed -e 's/^/                /'>> transcript.aln
  echo ">query" > query.fa
  tail -1 transcript.aln | sed -e 's/ //g' >> query.fa
  revseq -sequence query.fa -outseq query_rc.fa -noreverse
  grep -v '^>' query_rc.fa | sed -e 's/^/                /'>> transcript.aln
  grep -v '^>' transcript_rc.fa   | sed -e "s/^/3\'-/" | sed -e "s/$/-5\'/" >> transcript.aln
  grep '^>' transcript.fa | sed -e 's/>//'  >> transcript.aln
  echo "" >> transcript.aln
done
mv transcript.aln $1_aln.doc
