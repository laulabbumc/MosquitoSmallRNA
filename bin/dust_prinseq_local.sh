#!/bin/bash
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
 dust $1 80 > $1.dust.80 ; perl $INSTALLATION_PATH/prinseq-lite.pl -verbose -fasta $1.dust.80 -ns_max_n 13  -min_len 18 -max_len 35  -out_good $1.good  -out_bad $1.bad ; mv $1.good.fasta $1 
