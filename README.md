# Mosquito Small RNA Genomics resource pipeline

## Overview

The Mosquito Small RNA Genomics (MSRG) resource is a repository of analyses on the small RNA transcriptomes of mosquito cell cultures and somatic and gonadal tissues. This resource allows for comparing the regulation dynamics of small RNAs generated from transposons and viruses across mosquito species. This chapter covers the procedures to set up the MSRG resource pipeline as a new installation by detailing the necessary collection of genome reference and annotation files and lists of microRNAs (miRNAs) hairpin sequences, transposon repeats consensus sequences, and virus genome sequences. Proper execution of the MSRG resource pipeline yields outputs amenable to biologists to further analyze with desktop and spreadsheet software to gain insights into the balance between arthropod endogenous small RNA populations and the proportions of virus-derived small RNAs that include Piwi-interacting RNAs (piRNAs) and endogenous small interfering RNAs (siRNAs).

## Installation


## Usage

PATH=$PATH:$YOUR_OWN_CUSTOM_INSTALLATION_PATH
 
This guide explains how to read the outputs in the MSRG database. The outputs are generarted by a series of custom Shell, Perl, C and Python scripts avaiable on this GitHub page.

Example for running the script, gene_centric_test: 
$ bash /[YOUR_OWN_CUSTOM_INSTALLATION_PATH]/gene-centric.sh AnGam_Fcarc_TN.fastq Angam AGATCGGAAG 20000000 5

Example for running the script, TE_virus_test: 
$ bash /[YOUR_OWN_CUSTOM_INSTALLATION_PATH]/TE_virus_pipeline.sh AnGam_Fcarc_TN ../gene_centric_test/summary Angam AGATCGGAAG

Example for running the script, phasing_test:
$ bash /[YOUR_OWN_CUSTOM_INSTALLATION_PATH]/sRNA_Phasing_pipeline.sh AnGam_Fcarc_TN.fastq Angam AGATCGGAAG

Example for running the script, piRNA_target_test: 
$ bash /[YOUR_OWN_CUSTOM_INSTALLATION_PATH]/piRNA_target_pipeline.sh Angam_darkgreen.fa /[YOUR_OWN_CUSTOM_DATABASE_PATH]/Angam_transcript_TE_virus.fa 

