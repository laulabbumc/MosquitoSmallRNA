# Mosquito Small RNA Genomics resource pipeline

## Overview

The Mosquito Small RNA Genomics (MSRG) resource is a repository of analyses on the small RNA transcriptomes of mosquito cell cultures and somatic and gonadal tissues. This resource allows for comparing the regulation dynamics of small RNAs generated from transposons and viruses across mosquito species. This chapter covers the procedures to set up the MSRG resource pipeline as a new installation by detailing the necessary collection of genome reference and annotation files and lists of microRNAs (miRNAs) hairpin sequences, transposon repeats consensus sequences, and virus genome sequences. Proper execution of the MSRG resource pipeline yields outputs amenable to biologists to further analyze with desktop and spreadsheet software to gain insights into the balance between arthropod endogenous small RNA populations and the proportions of virus-derived small RNAs that include Piwi-interacting RNAs (piRNAs) and endogenous small interfering RNAs (siRNAs).

## Standard Tools Used

The following software packages are used by the pipeline. We list the version that we used for testing:

- [python3/3.8.10](https://www.python.org/downloads/release/python-3810/)
- [cutadapt/3.4](https://cutadapt.readthedocs.io/en/stable/installation.html)
- [bedops/2.4.35](https://bedops.readthedocs.io/en/latest/content/installation.html)
- [perl/5.34.0](https://www.perl.org/get.html)
- [bedtools/2.27.1](https://bedtools.readthedocs.io/en/latest/content/installation.html)
- [bowtie/1.0.0](https://sourceforge.net/projects/bowtie-bio/files/bowtie/1.0.0/)
- [samtools/1.10](http://www.htslib.org/)
- [blast/2.2.26](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
- [fastx-toolkit/0.0.14](http://hannonlab.cshl.edu/fastx_toolkit/download.html)
- [R/4.1.1](https://cran.r-project.org/)
- [bedtobigbed/2.6](https://www.encodeproject.org/software/bedToBigBed/)
- [ucscutils/2018-11-27](http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/FOOTER)
 

## Installation

To download the source code for the pipeline, execute:
	git clone https://github.com/laulabbumc/MosquitoSmallRNA.git


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
- Repeatmasker.bed file


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

Trimmed reads between 18-23nt length are extracted and mapped to miRNA hairpin sequences using Bowtie with 2 mismatches. These reads are counted for either mapping to the 5' or 3' end of the hairpin miRNA precursor sequence, depending on where the more abundant guide strand is generated by the cells or tissues. 


### Step 3

    $msrg/scripts/step3_extract-s_and_pi-RNA.sh $i

Removing low complexity counts, extracting 18-23nt long small RNA reads, and extracting 24-35nt long piRNA reads.

### Step 4

    $msrg/scripts/step4_transposon.sh $i

Mapping the reads to a database built from a multi-fasta file of transposon consensus sequences. Generates a TSV/XLS file of the sense and antisense small RNA mapping counts with up to 2 nt mismatch binned by 18-23nt and 24-35nt bins. Generates a matching PDF file that are an R-script based graphical plot of the small RNA read coverage across each transposon entry. Entries are then sorted according to a ratio calculation of number of read peaks / distance between peaks to rank highest the entries with the broadest coverage of mapping reads across the transposon entry. 

### Step 5

    $msrg/scripts/step5_virus.sh $i

Similar to Step 4 but using a list of virus genome sequences in the database to generate these outputs.  The virus sequences database is from a manually curated list.

### Step 6

    $msrg/scripts/step6_srna_structure.sh $i
    
Similar to Step 4 but using a list of structural RNA sequences in the database to generate these outputs. Structural RNAs would be ribosomal and transfer RNAs, snoRNAs and snRNAs. This structural RNA sequences database is from a manually curated list.

### Step 7

    $msrg/scripts/step7_wolbachia.sh $i
   
Similar to Step 4 but using a list of Wolbachia bacteria genome sequences in the database to generate these outputs.  The Wolbachia sequences database is from a manually curated list.

### Step 8

    $msrg/scripts/step8_phasing.sh $i

The counts and length distributions generated during various steps such as Gene-centric and miRNA analysis are saved during each of the steps (Fig. 1). These scripts now send final results files generated in steps above to a consolidated results folder for sharing or posting. In addition, the wigToBigWig script is used to convert the fixed step WIG file to the Bigwig file which can be visualized on the Broad Institute Integrative Genomics Viewer together with the genome assembly and GTF files.  Finally, there are scripts implimenting a phasing alorithm derived from Gainetdinov et al (Zamore) Mol Cell 2018: DOI: 10.1016/j.molcel.2018.08.007 to measure the piRNA biogenesis phasing patterns in mosquito piRNA and siRNA datasets.


