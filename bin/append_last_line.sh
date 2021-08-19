#!/bin/bash 

echo $1 `grep -v '^Chromosome' $1 | awk  -F'	'  'function abs(v) {return v < 0 ? -v : v} BEGIN { count=0;distance_sum=0; previous_position=0} { sum=0;for (i =3; i <= NF; i++) { sum=sum+abs($i);} if (sum>0) { count=count+1;if (count ==1) { previous_position=$2; distance_sum=50;  } else { distance_sum=distance_sum+$2-previous_position  ; previous_position=$2; } } } END { print count; if (count >0) {print distance_sum/count; print (count*count)/distance_sum; } else { print 0; print 0; } }' `  | awk '{print $1"\t"$2"\t"$3"\t"$4}'  >> TE_virus_peaks.txt
tail -1  $1  | awk -F'	' '{ print $1"\t"$2+50; for (i =3; i <= NF; i++) { print $i; } }'  | tr '\n' '\t'   >>  $1
