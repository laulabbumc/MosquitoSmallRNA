#!/bin/bash
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
DATABASE_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/database
#$1  sample
#$2 organism name, for example $2
# $DATABASE_PATH/repeat_$2  is the repeat database
plot_window_size=1
mismatch=2
#
# the input file is $1.trim.fastq.uq.polyn
#
bowtie -f -v $mismatch -S -k 100000 -m 100000 --strata --best -p 1 $DATABASE_PATH/repeat_$2 $1.trim.fastq.uq.polyn z0.$1
grep -v '	4	\*	0	0	\*	\*	0	0	' z0.$1 > $1.rep.sam
rm z0.$1
python  $INSTALLATION_PATH/extract_sam_by_min_PM_max_NM.py $1.rep.sam 20 2   tmp.sam  # 0  for Wolbachia, 1 for virus and structure RNA, 2 for TE
mv tmp.sam $1.rep.sam

#grep '^@' z0.$1 > $1.rep.sam
#cat z0.$1 z1.$1 | grep -v '^@' | grep -v '	4	\*	0	0	\*	\*	0	0	' | sort -u >> $1.rep.sam

echo -n "$1	rep/vir-mapped	" >> summary; grep -v '^@' $1.rep.sam | cut -f1 | sort -u | cut -d':' -f2 | sum >> summary

#
#############################
## make bed file   
#############################
grep    '^@' $1.rep.sam > z5.$1
grep -v '^@' $1.rep.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*	0	' >> z5.$1
grep    '^@' $1.rep.sam > z6.$1
grep -v '^@' $1.rep.sam | grep '[ACTGN][ACTGN]*:[0-9][0-9]*	16	' >> z6.$1
samtools view -bS z5.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1
cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	255,0,0/' > z9.$1
samtools view -bS z6.$1 > z7.$1
bamToBed -i z7.$1 > z8.$1
cut -f2,3 z8.$1 | paste z8.$1 - | sed 's/$/	0,0,255/' >> z9.$1
echo "track name=\"$1\" description=\"$1\" visibility=2 itemRgb=\"On\"" > $1.rep.bed
sort -T ./ +0 -1 +1 -2n +2 -3n z9.$1 >> $1.rep.bed


############################
##  put in SPLIT/
############################
grep -v '^#' $1.rep.bed | grep -v '^track ' | cut -f1 | uniq | sort -u > z0.$1

mkdir -p SPLIT
sed 's/\./\\./g' z0.$1 | sed "s/^/grep '^/" | sed "s/$/YYYGWCYYY' XXX/" | sed "s/XXX/$1.rep.bed/" > z1.$1
sed "s#^#'./SPLIT/$1.rep.bed-#" z0.$1 | sed 's/$/XXX/' | sed "s/XXX/'/" > z2.$1
paste z1.$1 z2.$1 | sed 's/	/ > /' | sed 's/YYYGWCYYY/	/' > z3.$1
chmod +x z3.$1
./z3.$1

echo -n "$1 transposon " >> summary
grep -v '^track' $1.rep.bed | grep -v '^virus=' | cut -f4 | sort -u | cut -d':' -f2 | sum >> summary

echo -n "$1 virus " >> summary
grep -v '^track' $1.rep.bed | grep '^virus=' | cut -f4 | sort -u | cut -d':' -f2 | sum >> summary

exit
sed "s/^/grep '^/"

exit



