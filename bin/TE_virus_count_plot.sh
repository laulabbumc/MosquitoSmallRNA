#!/bin/bash
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
DATABASE_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/database
# $DATABASE_PATH/$1\_structure_rna is the structure_rna
# $DATABASE_PATH/repeat_$1 is the TE/virus database
# $DATABASE_PATH/$1_refseq.bed is the genome gtf file
# $DATABASE_PATH/$1_repeat_masker.bed is one_line_TE_bed_file
# $INSTALLATION_PATH/plot_coverage_on_repeat.R is the R plotting script
# $INSTALLATION_PATH/append_last_line.sh is the append_last_line script
organism=${@:1:1}
echo $organism
n_sample=${@:2:1}
echo $n_sample
for (( i=1; i<=$n_sample; i++ ))
do
   a[$i]=${@:$(($i+2)):1}
   echo  ${a[$i]}
done
for (( i=1; i<=$n_sample; i++ ))
do
   total_read[$i]=${@:$(($i+2+$n_sample)):1}
   echo ${total_read[$i]}
done
for (( i=1; i<=$n_sample; i++ ))
do
   miRNA_samfile[$i]=${@:$(($i+2+$n_sample+$n_sample)):1}
   echo ${miRNA_samfile[$i]}
   lt_create_idx ${a[$i]}.trim.fastq.uq.polyn
   grep -v '^@' ${miRNA_samfile[$i]} | cut -f 1 | cut -d':' -f 1 | sed -e "s/^/>/" | sed -e "s/$/:/" | sort -u >  ${a[$i]}.sam.reads.txt
   grep '^>' ${a[$i]}.trim.fastq.uq.polyn | sort -u > ${a[$i]}.trim.fastq.uq.polyn.ids.txt
   fgrep -v -f ${a[$i]}.sam.reads.txt ${a[$i]}.trim.fastq.uq.polyn.ids.txt | sed -e 's/>//' > ${a[$i]}.trim.fastq.uq.polyn.filtered.ids  
   cat ${a[$i]}.trim.fastq.uq.polyn.filtered.ids | lt_retrieve ${a[$i]}.trim.fastq.uq.polyn > ${a[$i]}.trim.fastq.uq.polyn.filtered 
#   blat  $DATABASE_PATH/$1\_structure_rna ${a[$i]}.trim.fastq.uq.polyn.filtered -out=blast8 ${a[$i]}.trim.fastq.uq.polyn.filtered.structure_RNA.txt
blastall -p blastn -i ${a[$i]}.trim.fastq.uq.polyn.filtered  -d $DATABASE_PATH/$1\_structure_rna  -m 8  -o ${a[$i]}.trim.fastq.uq.polyn.filtered.structure_RNA.txt  -F none -e 0.01 -a 10 -b 100 -v 100 -z 10000000
awk -F'	' '{ if ($3>94) print $1}'  ${a[$i]}.trim.fastq.uq.polyn.filtered.structure_RNA.txt | sort -u > ${a[$i]}.trim.fastq.uq.polyn.filtered.structure_RNA.ids.txt
   fgrep -v -f ${a[$i]}.trim.fastq.uq.polyn.filtered.structure_RNA.ids.txt  ${a[$i]}.trim.fastq.uq.polyn.filtered.ids | lt_retrieve ${a[$i]}.trim.fastq.uq.polyn > ${a[$i]}.trim.fastq.uq.polyn.filtered 
   mv ${a[$i]}.trim.fastq.uq.polyn.filtered  ${a[$i]}.trim.fastq.uq.polyn
  
done


for (( i=1; i<=$n_sample; i++ ))
do
bash $INSTALLATION_PATH/align_to_repeat_virus.sh ${a[$i]} $organism
done


seq_stat -i $DATABASE_PATH/repeat_$1 | grep -v ': ' > z0


touch z1;rm z1;touch z1
while read id length
do
  echo -n "genome_coverage_plot_1 -g $id:1-$length -r -w 25  -s $1 -t $DATABASE_PATH/$1_refseq.bed -p $DATABASE_PATH/$1_repeat_masker.bed -u $INSTALLATION_PATH/plot_coverage_on_repeat.R -v $INSTALLATION_PATH/append_last_line.sh " >> z1
  for (( i=1; i<=$n_sample; i++ ))
  do
    echo -n " -d ${a[$i]}.rep.bed:${total_read[$i]}:0" >> z1
  done
  echo >> z1
done < z0
chmod +x z1

./z1


echo -n 'Transposon	Length' > TE_table.xls
for (( i=1; i<=$n_sample; i++ ))
do
  echo -n "	${a[$i]}(+)	${a[$i]}(-)" >> TE_table.xls
done
echo >> TE_table.xls

seq_stat -i $DATABASE_PATH/repeat_$1 | grep -v ': ' > z0

while read id length
do
  echo -n "$id	$length" >> TE_table.xls
  for (( i=1; i<=$n_sample; i++ ))
  do
    m=`echo "$i*2+1" | bc -l`
    n=`echo "$i*2+2" | bc -l`
    sum=`grep -v '^Chr' $id:1-$length | cut -f $m | awk '{sum+=$1} END {print sum}' `
    echo -n "	$sum" >> TE_table.xls
    sum=`grep -v '^Chr' $id:1-$length | cut -f $n | awk '{sum+=$1} END {print sum}'  | sed 's/-//'`
    echo -n "	$sum" >> TE_table.xls
  done
  echo >> TE_table.xls
done < z0

grep -v '^Transposon' TE_table.xls | cut -f3- | tr '\t' '+' | bc -l > z0
grep -v '^Transposon' TE_table.xls | cut -f1,2 | sed 's/	/:1-/' | paste - z0 | sort +1 -2rn | grep -v 'virus@' | cut -f1 > z1
grep -v '^Transposon' TE_table.xls | cut -f1,2 | sed 's/	/:1-/' | paste - z0 | sort +1 -2rn | grep    'virus@' | cut -f1 >> z1
echo 'gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=TE_virus.pdf -dBATCH \' > z0
sort -k 2 -b -n -r  TE_virus_peaks.txt   | cut -f 1 > z1
sed 's/$/-25-0-1.pdf \\/' z1 >> z0  ## need to modify
echo >> z0
chmod +x z0
./z0

mv TE_table.xls TE_virus.xls
mv TE_virus.pdf TE_virus.pdf

exit

