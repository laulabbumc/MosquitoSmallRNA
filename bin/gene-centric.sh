#!/bin/bash

# require the following program in $PATH
# 1) cutadapt
# 2) fastx_clipper
# 3) bowtie
# 4) samtools
# 5) bamToBed
# 6) intersectBed
# 7) lt_create_idx
# 8) seq_stat
# 9) ngs_coverage-nelson
# 10) ngs_genecentric


INSTALLATION_PATH=$bindir
DATABASE_PATH=$refdir


# $DATABASE_PATH/$2_virus is the virus database
# $DATABASE_PATH/hairpin_$2 is the miRNA database
# $DATABASE_PATH/ucsc_$2_genome is the genome file
# $DATABASE_PATH/$2_structurerna.bed is the structure RNA bed file
# $DATABASE_PATH/$2_TE is the repeat database
# $DATABASE_PATH/$2_refseq.bed is the genome bed file


#input argument
#$1 fastq file
#$2 organism name, for example fly
#$3 linker
#$4 jackpot_cutoff
#$5 extend_window


mismatch0=0
mismatch1=1
mismatch2=2
mismatch3=3
plot_window_size=25
extend_window=$5
cutoff=0.02

prefix=${1%.fastq*}


cutadapt -a $3  -e 0.1 $1 -o $prefix.cutadapt.fastq

bash $INSTALLATION_PATH/create_uq_from_fastq.sh  $prefix.cutadapt.fastq
mv $prefix.cutadapt.fastq.uq  $1.uq


total_read=`grep '^>' $1.uq | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `


#katia: summary is used the first time and the old version should be overwritten: change >> to >
echo "$1	total_read	$total_read" > summary

fastx_clipper -Q33 -a $3 -M 9 -n -l 20 -c -i $1.uq > $1.uq.clipped
fastx_clipper -Q33 -a $3 -M 9 -n -l 20 -C -i $1.uq > $1.uq.noclipped
cat $1.uq.noclipped  > z0.$1

exgrep    -b '>' 'X$' z0.$1 | sed 's/X$//' | sed 's/NN*$//' >> $1.uq.clipped
exgrep -v -b '>' 'X$' z0.$1 | \
grep -v '[AN][AN][AN][AN][AN][AN][AN][AN][AN][AN][AN][AN][AN]*' | \
grep -v '[CN][CN][CN][CN][CN][CN][CN][CN][CN][CN][CN][CN][CN]*' | \
grep -v '[GN][GN][GN][GN][GN][GN][GN][GN][GN][GN][GN][GN][GN]*' | \
grep -v '[TN][TN][TN][TN][TN][TN][TN][TN][TN][TN][TN][TN][TN]*' | \

$INSTALLATION_PATH/remove_poly_n > $1.uq.noclipped

grep    '^>' $1.uq.clipped | cut -d':' -f2 > z0.$1
grep -v '^>' $1.uq.clipped | paste - z0.$1 | sort +0 -1 +1 -2n | group -g 0 -a 1 -c -d '+' | sed 's/+$//' > z1.$1
cut -f2 z1.$1 | bc -l | paste z1.$1 - z1.$1 | cut -f1,3,4 | sed 's/^/>/' | sed 's/	/:/' | tr '\t' '\n' | \
grep -v '[AN][AN][AN][AN][AN][AN][AN][AN][AN][AN][AN][AN][AN]*' | \
grep -v '[CN][CN][CN][CN][CN][CN][CN][CN][CN][CN][CN][CN][CN]*' | \
grep -v '[GN][GN][GN][GN][GN][GN][GN][GN][GN][GN][GN][GN][GN]*' | \
grep -v '[TN][TN][TN][TN][TN][TN][TN][TN][TN][TN][TN][TN][TN]*' | \
$INSTALLATION_PATH/remove_poly_n > $1.uq.clipped

read_clipped=`grep '^>' $1.uq.clipped | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `
echo "$1	read_clipped	$read_clipped" | sed 's/	$/	0/' >> summary
read_noclipped=`grep '^>' $1.uq.noclipped | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `
echo "$1	read_noclipped	$read_noclipped" | sed 's/	$/	0/' >> summary

cat $1.uq.noclipped $1.uq.clipped > $prefix".trim.fastq.uq.polyn"

bowtie -f -v $mismatch1 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/$2_virus $1.uq.clipped z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 > $1.virus.sam
grep    '	4	\*	0	0	\*	\*	0	0	' z0.$1 | cut -f1 > z1.$1
paste z1.$1 z1.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.clipped.novirus
bowtie -f -v $mismatch2 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/$2_virus $1.uq.noclipped z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 | grep -v '^@' >> $1.virus.sam
grep    '	4	\*	0	0	\*	\*	0	0	' z0.$1 | cut -f1 > z1.$1
paste z1.$1 z1.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.noclipped.novirus

virus=`grep -v '^@' $1.virus.sam | cut -f1 | uniq | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `
echo "$1	virus	$virus" >> summary
rm z0.$1 z1.$1

bowtie -f -v $mismatch1 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/hairpin_$2 $1.clipped.novirus z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 > $1.struc_mirna.sam
grep    '	4	\*	0	0	\*	\*	0	0	' z0.$1 | cut -f1 > z1.$1
paste z1.$1 z1.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.clipped.nostruc
bowtie -f -v $mismatch2 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/hairpin_$2 $1.noclipped.novirus z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 | grep -v '^@' >> $1.struc_mirna.sam
grep    '	4	\*	0	0	\*	\*	0	0	' z0.$1 | cut -f1 > z1.$1
paste z1.$1 z1.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.noclipped.nostruc
rm z0.$1 z1.$1
mirna=`grep -v '^@' $1.struc_mirna.sam | egrep    '	14|miRNA:|-mir-' | cut -f1 | uniq | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `
echo "$1	mirna	$mirna" >> summary

bowtie -f -v $mismatch1 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/ucsc_$2_genome $1.clipped.nostruc z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 > $1.genome.sam
grep    '	4	\*	0	0	\*	\*	0	0	' z0.$1 | cut -f1 > z1.$1
paste z1.$1 z1.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.clipped.nogenome
bowtie -f -v $mismatch2 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/ucsc_$2_genome $1.noclipped.nostruc z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 | grep -v '^@' >> $1.genome.sam
grep    '	4	\*	0	0	\*	\*	0	0	' z0.$1 | cut -f1 > z1.$1
paste z1.$1 z1.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.noclipped.nogenome
nogenome=`cut -d':' -f2 z1.$1 | awk '{sum+=$1} END {print sum}' `
echo "$1	nogenome	$nogenome" >> summary
rm z0.$1 z1.$1

samtools view -bS $1.genome.sam > z0.$1
bamToBed -i z0.$1 > $1.genome.bed
rm z0.$1

grep -v '^@' $1.genome.sam | cut -f1 | sort -u > z0.$1
intersectBed -a $1.genome.bed -b $DATABASE_PATH/$2_structurerna.bed | cut -f4 | sort -u > $1.struc-2
comm -23 z0.$1 $1.struc-2 > z1.$1
paste z1.$1 z1.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.nono
struc=`cat $1.struc_mirna.sam $1.struc-2 | grep -v '^@' | cut -f1 | sort -u | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `
echo "$1	struc	$struc" >> summary
nono=`cut -d':' -f2 z1.$1 | awk '{sum+=$1} END {print sum}' `
echo "$1	nono (before filter)	$nono" >> summary
rm z0.$1 z1.$1
rm $1.genome.bed


perl $INSTALLATION_PATH/filter_reads_based_count.pl -f $1.nono -t $4  > dump.uq
mv dump.uq $1.nono

 
bowtie -f -v $mismatch2 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/ucsc_$2_genome $1.nono z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 > $1.genome.sam
rm z0.$1
genome_mapped=`grep -v '^@' $1.genome.sam | cut -f1 | uniq | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `
echo "$1	genome_mapped (number of mapped reads)	$genome_mapped" >> summary

grep '^@' $1.genome.sam > z0.$1
grep -v '^@' $1.genome.sam | grep    ':[0-9][0-9]*	4	\*' | cut -f1 | sed 's/^/0	/' > z1.$1
grep -v '^@' $1.genome.sam | grep -v ':[0-9][0-9]*	4	\*' | cut -f1 | $INSTALLATION_PATH/count >> z1.$1
touch z22.$1; rm z22.$1

for W in A C G N T
do
  grep "	$W" z1.$1 > z1.$W.$1
  for X in A C G N T
  do
    grep "	$W$X" z1.$W.$1 > z1.$W$X.$1
    for Y in A C G N T
    do
      grep "	$W$X$Y" z1.$W$X.$1 | sort +1 -2 >> z22.$1
    done
  done
done
mv z22.$1 z1.$1

touch z2.$1; rm z2.$1
for W in A C G N T
do
  grep "^$W" $1.genome.sam > z2.$W.$1
  for X in A C G N T
  do
  grep "^$W$X" z2.$W.$1 > z2.$W$X.$1
    for Y in A C G N T
    do
      grep "^$W$X$Y" z2.$W$X.$1 | sort +0 -1 >> z2.$1
    done
  done
done
join -t '	' -1 2 -2 1 z1.$1 z2.$1 | sed 's/	/:/' > z3.$1
cat z0.$1 z3.$1 > $1.genome-v2.sam
rm z*$1
rm $1.genome.sam

grep '^@'                         $1.genome-v2.sam >  $1.genome-v2-50.sam
grep ':[0-9][0-9]*:[0-9]	' $1.genome-v2.sam | grep -v '	4	\*	0	0	\*	\*	0	0	' >> $1.genome-v2-50.sam
grep ':[0-9][0-9]*:[1-4][0-9]	' $1.genome-v2.sam | grep -v '	4	\*	0	0	\*	\*	0	0	' >> $1.genome-v2-50.sam

grep    '^@' $1.genome-v2.sam > z5.$1
grep -v '^@' $1.genome-v2.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*:[0-9][0-9]*	0	' >> z5.$1
grep    '^@' $1.genome-v2.sam > z6.$1
grep -v '^@' $1.genome-v2.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*:[0-9][0-9]*	16	' >> z6.$1
samtools view -bS z5.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1
cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	255,0,0/' > z9.$1
samtools view -bS z6.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1
cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	0,0,255/' >> z9.$1
echo "track name=\"$1\" description=\"$1\" visibility=2 itemRgb=\"On\"" > $1.genome-v2.bed
sort -T ./ +0 -1 +1 -2n +2 -3n z9.$1 >> $1.genome-v2.bed
rm z*.$1

grep    '^@' $1.genome-v2-50.sam > z5.$1
grep -v '^@' $1.genome-v2-50.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*:[0-9][0-9]*	0	' >> z5.$1
grep    '^@' $1.genome-v2-50.sam > z6.$1
grep -v '^@' $1.genome-v2-50.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*:[0-9][0-9]*	16	' >> z6.$1
samtools view -bS z5.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1
cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	255,0,0/' > z9.$1
samtools view -bS z6.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1
cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	0,0,255/' >> z9.$1
echo "track name=\"$1\" description=\"$1\" visibility=2 itemRgb=\"On\"" > $1.genome-v2-50.bed
sort -T ./ +0 -1 +1 -2n +2 -3n z9.$1 >> $1.genome-v2-50.bed
rm z*.$1


read_clipped=`grep "^$1	read_clipped	" summary | tail -1 | cut -f3`
read_noclipped=`grep "^$1	read_noclipped	" summary | tail -1 | cut -f3`

nomorized_count=$genome_mapped
echo "$1	nomorized_count (number of mapped reads after applying threshold for high count )	$nomorized_count" >> summary

bowtie -f -v $mismatch1 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/$2_TE $1.uq.clipped z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 > $1.rep_vir.sam
bowtie -f -v $mismatch2 -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/$2_TE $1.uq.noclipped z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 | grep -v '^@' >> $1.rep_vir.sam

grep -v '^@' $1.rep_vir.sam | cut -f1,3 | sort -u | cut -d':' -f2- | sort +1 -2 +0 -12n | group -g 1 -a 0 -c -d '+' | sed 's/+$//' > z0.$1
cut -f2 z0.$1 | bc -l | paste z0.$1 - | cut -f1,3 | sed 's/^/>/' > rep_vir_count.$1
$INSTALLATION_PATH/lt_create_idx rep_vir_count.$1 -q


cat $1.genome-v2.sam $1.rep_vir.sam | grep -v '^@' | cut -f1 | cut -d':' -f1-2 | uniq | sort -u > z0.$1
paste z0.$1 z0.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' | $INSTALLATION_PATH/seq_stat | grep -v ': ' > z1.$1

coverage_mapped_to_genome_rep_vir=`cut -d':' -f2- z1.$1 | sed 's/:[0-9][0-9]*//' | sed 's/^/(/' | sed 's/	/*/' | sed 's/$/)/' | $INSTALLATION_PATH/sum`
read_count_mapped_to_genome_rep_vir=`cut -f1 z1.$1 | cut -d':' -f2 | $INSTALLATION_PATH/sum`
avg_read_length_mapped_to_genome_rep_vir=`echo "$coverage_mapped_to_genome_rep_vir/$read_count_mapped_to_genome_rep_vir" | bc -l`


#coverage_mapped_to_genome_rep_vir=`cut -d':' -f2- z1.$1 | sed 's/:[0-9][0-9]*//' | sed 's/^/(/' | sed 's/	/*/' | sed 's/$/)/' | awk '{sum+=$1} END {print sum}' `
#read_count_mapped_to_genome_rep_vir=`cut -f1 z1.$1 | cut -d':' -f2 | awk '{sum+=$1} END {print sum}' `
#avg_read_length_mapped_to_genome_rep_vir=`echo "$coverage_mapped_to_genome_rep_vir/$read_count_mapped_to_genome_rep_vir" | bc -l`
echo "$1	read_count_mapped_to_genome_rep_vir	$read_count_mapped_to_genome_rep_vir" >> summary
echo "$1	coverage_mapped_to_genome_rep_vir	$coverage_mapped_to_genome_rep_vir" >> summary
echo "$1	avg_read_length_mapped_to_genome_rep_vir	$avg_read_length_mapped_to_genome_rep_vir" >> summary

read_clipped=`grep "^$1	read_clipped	" summary | tail -1 | cut -f3`
read_noclipped=`grep "^$1	read_noclipped	" summary | tail -1 | cut -f3`
nomorized_count=`echo "$read_clipped + $read_noclipped" | bc -l`
echo $nomorized_count

echo "ngs_coverage-nelson -i $1.genome-v2-50.sam -o $1.genome-v2-50-coverage-w$plot_window_size-$cutoff -w $plot_window_size -m 4 -a 2 -r $nomorized_count -c $cutoff "
$INSTALLATION_PATH/ngs_coverage-nelson -i $1.genome-v2-50.sam -o $1.genome-v2-50-coverage-w$plot_window_size-$cutoff -w $plot_window_size -m 4 -a 2 -r $nomorized_count -c $cutoff
grep -v '^ERROR' $1.genome-v2-50-coverage-w$plot_window_size-$cutoff > tmp; mv tmp $1.genome-v2-50-coverage-w$plot_window_size-$cutoff
grep '^#' $1.genome-v2-50-coverage-w$plot_window_size-$cutoff > $1.genome-v2-50-coverage-w$plot_window_size-$cutoff-collapsed.xls

sed 's/\.00*	/	/g' $1.genome-v2-50-coverage-w$plot_window_size-$cutoff | sed 's/\.00*$//' > z0.$1
mv z0.$1 $1.genome-v2-50-coverage-w$plot_window_size-$cutoff
grep -v '^#' $1.genome-v2-50-coverage-w$plot_window_size-$cutoff > w1.$1
cut -f1,10 w1.$1 > z0.$1
step=`head -2 z0.$1 | grep -v stop | cut -f1 | cut -d'-' -f2`

cut -f1,9 w1.$1 > z0.$1
cut -d':' -f1 z0.$1 | grep -v '^id' | uniq > z1.$1
echo "track type=wiggle_0 name='$1-Nrm-(-)' description='Read coverage ($1, Normalized, negative strand)' color=0,0,255" > $1-nor-ngtv-$plot_window_size-$cutoff.wig
for i in `cat z1.$1`
do
  echo "fixedStep chrom=$i start=1 step=$step" >> $1-nor-ngtv-$plot_window_size-$cutoff.wig
  grep "^$i\:" z0.$1 | cut -f2 >> $1-nor-ngtv-$plot_window_size-$cutoff.wig
done

cut -f1,8 w1.$1 > z0.$1
cut -d':' -f1 z0.$1 | grep -v '^id' | uniq > z1.$1
echo "track type=wiggle_0 name='$1-Nrm-(+)' description='Read coverage ($1, Normalized, positive strand)' color=255,0,0" > $1-nor-pstv-$plot_window_size-$cutoff.wig
for i in `cat z1.$1`
do
  echo "fixedStep chrom=$i start=1 step=$step" >> $1-nor-pstv-$plot_window_size-$cutoff.wig
  grep "^$i\:" z0.$1 | cut -f2 >> $1-nor-pstv-$plot_window_size-$cutoff.wig
done

cut -f1,6 w1.$1 > z0.$1
cut -d':' -f1 z0.$1 | grep -v '^id' | uniq > z1.$1
echo "track type=wiggle_0 name='$1-Unq-(-)' description='Read coverage ($1, Unique-mapped, negative strand)' color=0,128,128" > $1-unq-ngtv-$plot_window_size-$cutoff.wig
for i in `cat z1.$1`
do
  echo "fixedStep chrom=$i start=1 step=$step" >> $1-unq-ngtv-$plot_window_size-$cutoff.wig
  grep "^$i\:" z0.$1 | cut -f2 >> $1-unq-ngtv-$plot_window_size-$cutoff.wig
done

cut -f1,5 w1.$1 > z0.$1
cut -d':' -f1 z0.$1 | grep -v '^id' | uniq > z1.$1
echo "track type=wiggle_0 name='$1-Unq-(+)' description='Read coverage ($1, Unique-mapped, positive strand)' color=128,128,0" > $1-unq-pstv-$plot_window_size-$cutoff.wig
for i in `cat z1.$1`
do
  echo "fixedStep chrom=$i start=1 step=$step" >> $1-unq-pstv-$plot_window_size-$cutoff.wig
  grep "^$i\:" z0.$1 | cut -f2 >> $1-unq-pstv-$plot_window_size-$cutoff.wig
done

echo " ngs_genecentric -r $DATABASE_PATH/$2_refseq.bed -e $extend_window -v $1.genome-v2-50-coverage-w$plot_window_size-$cutoff -m $1.genome-v2-50.bed -o genecentric_$1-$plot_window_size-$cutoff.xls -n $nomorized_count  "
$INSTALLATION_PATH/ngs_genecentric -r $DATABASE_PATH/$2_refseq.bed -e $extend_window -v $1.genome-v2-50-coverage-w$plot_window_size-$cutoff -m $1.genome-v2-50.bed -o genecentric_$1-$plot_window_size-$cutoff.xls -n $nomorized_count 
perl  $INSTALLATION_PATH/collapse_isoforms.pl genecentric_$1-$plot_window_size-0.02.xls  >  genecentric_$1-$plot_window_size-0.02.collapsed.xls
exit
