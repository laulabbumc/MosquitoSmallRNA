#!/bin/bash

DATABASE_PATH=$refdir

blastall -p blastn -i $1.uq -d $DATABASE_PATH/hairpin_$2 -o $1.hairpin.blast -F none -e 0.01 -a 10 -b 100 -v 100 -z 10000000
blast_to_sam -i $1.hairpin.blast -o z0.$1 -b
cp z0.$1 $1.hairpin.sam

grep '^>' $1.uq | cut -d'>' -f2- > z0.$1
grep -v '^@' $1.hairpin.sam | cut -f1 | uniq > z1.$1
comm -23 z0.$1 z1.$1 > z2.$1
paste z2.$1 z2.$1 | cut -d':' -f1,2 | sed 's/^/>/' | tr '\t' '\n' > $1.nomir

