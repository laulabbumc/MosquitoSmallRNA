USER GUIDE TO Mosquito Small RNA Genomics v. 1.0 OUTPUTS (updated 2020-04-01)

This guide explains how to read the outputs in the MSRG database. The outputs are generarted by a series of custom Shell, Perl, C and Python scripts avaiable on this GitHub page.

Example for running the script, gene_centric_test: 
$ bash /[YOUR OWN CUSTOM INSTALLATION PATH]/gene-centric.sh AnGam_Fcarc_TN.fastq Angam AGATCGGAAG 20000000 5

Example for running the script, TE_virus_test: 
$ bash /[YOUR OWN CUSTOM INSTALLATION PATH]/TE_virus_pipeline.sh AnGam_Fcarc_TN ../gene_centric_test/summary Angam AGATCGGAAG

Example for running the script, phasing_test:
$ bash /[YOUR OWN CUSTOM INSTALLATION PATH]/sRNA_Phasing_pipeline.sh AnGam_Fcarc_TN.fastq Angam AGATCGGAAG

Example for running the script, piRNA_target_test: 
$ bash /[YOUR OWN CUSTOM INSTALLATION PATH]/piRNA_target_pipeline.sh Angam_darkgreen.fa /[YOUR OWN CUSTOM INSTALLATION PATH]/Angam_transcript_TE_virus.fa 

