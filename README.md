# Mosquito Small RNA Genomics resource pipeline

## Overview

The Mosquito Small RNA Genomics (MSRG) resource is a repository of analyses on the small RNA transcriptomes of mosquito cell cultures and somatic and gonadal tissues. This resource allows for comparing the regulation dynamics of small RNAs generated from transposons and viruses across mosquito species. This chapter covers the procedures to set up the MSRG resource pipeline as a new installation by detailing the necessary collection of genome reference and annotation files and lists of microRNAs (miRNAs) hairpin sequences, transposon repeats consensus sequences, and virus genome sequences. Proper execution of the MSRG resource pipeline yields outputs amenable to biologists to further analyze with desktop and spreadsheet software to gain insights into the balance between arthropod endogenous small RNA populations and the proportions of virus-derived small RNAs that include Piwi-interacting RNAs (piRNAs) and endogenous small interfering RNAs (siRNAs).

## Standard Tools Used

THe following software packages are used by the pipeline. We list the version that we used for testing:

- python3/3.8.10
- cutadapt/3.4
- bedops/2.4.35
- perl/5.34.0
- bedtools/2.27.1
- bowtie/1.0.0
- samtools/1.10
- blast/2.2.26
- fastx-toolkit/0.0.14
- R/4.1.1
- bedtobigbed/2.6
- ucscutils/2018-11-27
 

## Installation


## Usage

To run the pipeline, the following scripts need to be executed:

### Set - up environment

    # Set current path (it should contain a directory with an input Fastq file)
    cd /path/to/current/dir

    export msrg=/path/to/MSRG
    echo "msrg: $msrg"

    # Copy a file that is used to set-up environment
    cp $msrg/scripts/msrg-set-input.sh .


Open the above set-up file with a text editor and specify environment variables, for example:

    export organism=Aeaeg
    export adapter=TGGAATTCTC
    export cutoff=20000000
    export window=5

    # input directory name (corresponding to a line in a sample file)
    export i=$1

    # location of the reference directory
    export refdir=/path/to/reference

Save the file and source it.
Specify the name of the directory with an input Fastq file as an input to the script. 
**Important**: The fastq file name should be the same as the directory name!

    source msrg-set-input.sh AeAAeg_Aag2_V5eGFP

Add directories with scripts and 3rd-party tools to the path.
This can be done by adjusting the following script and then sourcing it:

source $msrge/scripts/msrg-set-env.sh 



### Step 1
#### Find genes and intergenic regions with mapping small RNAs


    $msrg/scripts/step1_gene-centric.sh $i

The following reference files are used diring this step
- Virus genomes
- miRNA hairpins
- Animal genome
- Structural RNAs
- TE consensus sequences
- Refseq.bed transcripts


This step produces the following output files:
- cutadapt
- stats
- summary
- clipped
- novirus
- sam
- nostructure
- v2_50 ( sam and bed)
- nogenome
- wig/bigwig
- coverage


### Step 2

    $msrg/scripts/step2_miRNA.sh $i


### Step 3

    $msrg/scripts/step3_extract-s_and_pi-RNA.sh $i


### Step 4

    $msrg/scripts/step4_transposon.sh $i


### Step 5

    $msrg/scripts/step5_virus.sh $i


### Step 6

    $msrg/scripts/step6_srna_structure.sh $i

### Step 7

    $msrg/scripts/step7_wolbachia.sh $i

### Step 8

    $msrg/scripts/step8_phasing.sh $i



