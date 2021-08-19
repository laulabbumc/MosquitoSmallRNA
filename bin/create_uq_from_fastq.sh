#!/bin/sh


################################
## Create .uq .qc .stat file ###
################################
mkdir -p $1.DIR
cd $1.DIR
grep -A 1 "^@$head" ../$1 | grep -v '^-' | grep -v "^@$head" > $1.z0
for W in A C G N T
do
  grep "^$W" $1.z0 > $1.z0.$W
done

for W in A C G N T
do
  for X in A C G N T
  do
    grep "^$W$X" $1.z0.$W > $1.z0.$W$X
  done
done
####for W in A C G N T
####do
####  for X in A C G N T
####  do
####    for Y in A C G N T
####    do
####      grep "^$W$X$Y" $1\_1.z0.$W$X > $1\_1.z0.$W$X$Y
####      grep "^$W$X$Y" $1\_2.z0.$W$X > $1\_2.z0.$W$X$Y
####    done
####  done
####done

touch $1.uq; rm $1.uq
echo '0	0' > $1.z0
for W in A C G N T
do
  for X in A C G N T
  do
    for Y in A C G N T
    do
        grep "^$W$X$Y" $1.z0.$W$X | sort > $1.$W$X$Y
        count $1.$W$X$Y > $1.$W$X$Y.count
        paste $1.$W$X$Y.count $1.$W$X$Y.count | cut -f2-4 | sed 's/^/>/' | sed 's/	/:/' | tr '\t' '\n' | grep -v '^>0$' >> $1.uq
        cut -f1 $1.$W$X$Y.count | sort -n | count > $1.$W$X$Y.count.stat
        cat $1.$W$X$Y.count.stat | sed 's/	[0-9][0-9][0-9]*$/	10+/' >> $1.z0
    done
  done
done

sort +1 -2n +0 -1n $1.z0 | group -g 1 -a 0 -d '+' -c | sed 's/+$//' > $1.z1
cut -f2- $1.z1 | bc -l | paste $1.z1 - | cut -f1,3 | sed 's/^0	.*/Freq	Count/' > $1.stat
mv $1.uq ..
mv $1.stat ..
cd ..
