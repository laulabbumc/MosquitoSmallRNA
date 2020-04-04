#!/bin/bash
# $1 is the sample name
# $2 is the summary file
# $3 is the organism
# $4 is the adaptor 
INSTALLATION_PATH=/projectnb/lau-bumc/qichengm/software/mosquitoSmallRNA/bin
i=`head -n 13 $2 | grep 'total_read' | awk '{print $3}'` ; j=`head -n 13 $2 | grep 'nogenome'  | awk '{print $3}'` ; k=`expr $i - $j`
bash $INSTALLATION_PATH/process_smRNA.sh $1.fastq $4
bash $INSTALLATION_PATH/ngs_smrna_pipeline.sh $1 $3
python  $INSTALLATION_PATH/extract_sam_by_readseq_length.py $1.hairpin.sam 18 23 $1.hairpin.18.23.sam 
python  $INSTALLATION_PATH/extract_sam_by_min_PM_max_NM.py $1.hairpin.18.23.sam 17 1 $1.hairpin.sam
perl $INSTALLATION_PATH/get_read_count_from_sam.pl -r $k -s $1.hairpin.sam  > $1.miRNA_count.xls
