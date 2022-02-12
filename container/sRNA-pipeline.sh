#!/bin/bash -l

if [ $# -eq 0 ]
  then
    echo "Please provide an input directory name, where fastq file is stored."; exit;
fi

if [ "$#" -lt 3 ]
  then
    mailflag="-m n"
  else
    mailflag="$2 $3"
fi

# create a logs directory for job output files
mkdir -p logs

export msrg=/msrg

echo "msrg: $msrg"


# Step 1
echo "Submitting a job for step 1"
qsub $mailflag -l h_rt=36:00:00 -N  gene_centric_$1 $msrg/scripts/step1_gene-centric.qsub $1


# Step 2
echo "Submitting a job for step 2"
qsub $mailflag -hold_jid gene_centric_$1 -N miRNA_$1 $msrg/scripts/step2_miRNA.qsub $1


# Step 3
echo "Submitting a job for step 3"
qsub $mailflag -hold_jid miRNA_$1 -N extract_$1 $msrg/scripts/step3_extract-s_and_pi-RNA.qsub $1


# Step 4
echo "Submitting a job for step 4"
qsub $mailflag -hold_jid extract_$1 -N transposon_$1 $msrg/scripts/step4_transposon.qsub $1


# Step 5
echo "Submitting a job for step 5"
qsub $mailflag -hold_jid transposon_$1 -N virus_$1 $msrg/scripts/step5_virus.qsub $1


#Step 6
echo "Submitting a job for step 6"
qsub $mailflag -hold_jid virus_$1 -N srna_structure_$1 $msrg/scripts/step6_srna_structure.qsub $1

#Step 7
echo "Submitting a job for step 7"
qsub $mailflag -hold_jid srna_structure_$1 -N wolbachia_$1 $msrg/scripts/step7_wolbachia.qsub $1

#Step 8
echo "Submitting a job for step 8"
qsub $mailflag -hold_jid wolbachia_$1 -N phasing_$1 $msrg/scripts/step8_phasing.qsub $1


