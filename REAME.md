USER GUIDE TO Mosquito Small RNA Genomics v. 1.0 OUTPUTS (updated 2020-04-01)

This guide explains how to read the outputs in the MSRG database. The outputs are generarted by a series of custom Shell, Perl, C and Python scripts avaiable on this GitHub page.

Example for running the script, gene_centric_test: $ more tt bash /[YOUR OWN CUSTOM INSTALLATION PATH]/software/mosquitoSmallRNA/bin/gene-centric.sh AnGam_Fcarc_TN.fastq Angam AGATCGGAAG 20000000 5

Example for running the script, TE_virus_test: $ more tt bash /[YOUR OWN CUSTOM INSTALLATION PATH]/software/mosquitoSmallRNA/bin/TE_virus_pipeline.sh AnGam_Fcarc_TN ../gene_centric_t est/summary Angam AGATCGGAAG

Example for running the script, phasing_test: $ more tt bash /[YOUR OWN CUSTOM INSTALLATION PATH]/software/mosquitoSmallRNA/bin/sRNA_Phasing_pipeline.sh AnGam_Fcarc_TN.fastq Angam AG ATCGGAAG

Example for running the script, piRNA_target_test: $ more tt bash /[YOUR OWN CUSTOM INSTALLATION PATH]/software/mosquitoSmallRNA/bin/piRNA_target_pipeline.sh Angam_darkgreen.fa /[YOUR OWN CUSTOM INSTALLATION PATH]/software/mosquitoSmallRNA/database/Angam_transcript_TE_virus.fa 

Each folder is named according to the library ID name. Click the links below to see the detailed descriptions of each text file tables. Tab-delimited text file tables are easily importable into MS Excel for sorting, or into MS Access or Filemaker Pro for database queries with Structured Query Language (SQL)

(1) Summary File: text file of statistics of read counts passing through each stage of TIDAL pipeline.
(2) TE Insertions Annotated : tab-delim table of TE insertions with genomic annotation information.
(3) TE Depletions Annotated : tab-delim table of TE depletions with genomic annotation information. Note: this file was extracted from the All Dels. Annotated file.
(4) Fixed Bin Table : tab-delim table of 5kb genomic intervals with counts of TE InDels.
(5) TE Genome Chart : PDF file graphical display of density of TE InDels across the Release 6 / Dm6 reference genome. The Red dots represent TE insertions, Blue dots represent TE depletions, and these are broken down according the Coverage Ratio (CR) values greater and equal to 4 or less than 4. Dark red dots and dark blue dots have 10 or more reads per insertion or depletion, respectively.
(6) TE Ins. BED File : for uploading to UCSC Genome browser to display predicted TE Insertions.
(7) TE Dels. BED File : for uploading to UCSC Genome browser to display predicted TE Depletions.
(8) All Dels. Annotated : tab-delim table of All Depletions with genomic annotation information,including many smaller deletions. Note: Sorting this file just for TEs yields the TE Depletion Annotated file. For Depletions that do not include a TE, the repName field is blank. All the other column headers are identical and explained for TE Depletions Annotated.
(9) All Dels. BED File : for uploading to UCSC Genome browser to display all predicted Depletions, including many smaller deletions.
(10) TE Ins. Reads : tab delim table of the specific reads selected for calling each TE Insertion. From this table, you can select the cluster of reads and use BLAT to query on the UCSC browser to reveal the specific insertion breakpoint.
(11) All Dels. Reads : tab delim table of the specific reads selected for calling each Depletion. From this table, you can select the cluster of reads and use BLAT to query on the UCSC browser to reveal the specific depletion breakpoint.
(12) CNV Ratio Genome Chart : PDF file graphical display of the estimated Copy Number Variation Ratio for 5kb genomic intervals across the Release 6 / Dm6 reference genome. Ratios are based on assumption of 2N diploid genome for animal genomes, but only average undetermined ploidy for cell lines.


DETAILS FOR PARTICULAR MSRG OUTPUT FILES:

Summary File (LibName_summary.txt) : text file of statistics of read counts passing through each stage of TIDAL pipeline.

The numbers in each section reports the number of total and Uniquefied reads (Abbreviated "uq" for unique read sequences with molecule sampling frequency removed). For example, in this sample section, the reads from the S2c1 library were mapped to the reference genome with Bowtie2. The first numerical column is the number of reads going into the filter, the second column reports the reads coming out of the filter (reads that Do NOT readily map to the reference genome), and the percentage of the reads passing this filter is the third column.

^^^^^^

TE Insertions Annotated (LibName_Inserts_Annotated.txt) : tab-delim table of TE insertions with genomic annotation information.

SV# : Structural variant number (sequential, ordered by genome coordinate order)
Chr : Chromosome
Chr_coord_5p : 5' genomic coordinate boundary of the reads forming the cluster of TE insertion reads.
Chr_coord_3p : 3' genomic coordinate boundary of the reads forming the cluster of TE insertion reads.
TE : name of TE family
TE_coord_start : deepest 5' end coordinate of the cluster of reads mapping in the TE's consensus sequence.
TE_coord_end : deepest 3' end coordinate of the cluster of reads mapping in the TE's consensus sequence.
Reads_collapsed : number of reads forming the read cluster demarcating new TE insertion (current minimum is 4 reads).
Chr_Coord_Dist : number of bases between the Chr_coord_5p and the Chr_coord_3p values. Should be no greater than 300bp (2x length of longest Illumina read, 150bp).
Symmetry : approximation of how many reads on either side of the TE insertion.
avg_blat_score : the average BLAT score for the cluster of reads marking the TE insertion. Entries are filtered so that false positives with average BLAT scores >83 are removed.
Norm_RefGen_Reads : approximation of the read coverage count for the reference genome mapping reads falling within the Chr_coord_5p and the Chr_coord_3p window, used in the calculation of the Coverage Ratio.
Coverage_Ratio : Calculation of TE insertion reads over reference genome reads plus a pseudocount. Insertion CR = (TE reads) / (RefGen reads+1). The "1" is a pseudocount.
classification : Type of functional genomic annotation based on the genomic coordinate (intron, exon, 3'UTR, 5'UTR, or intergenic)
comments : Name of the RefSeq gene nearest to the TE insertion coordinates, along with the genomic strand orientation of the gene. Note: the nearest gene is not necessarily the only gene with impacted expression; sometimes a more downstream gene exhibits an effect from the TE.
insert_code : A unique identifier string for SQL analyses. Combination of chromosome, reads_collapsed, and chromosome start coordinates rounded down to lowest 5kb interval. 
loci_code : A unique identifier string for SQL analyses. Combination of chromosome, and chromosome start coordinates rounded down to lowest 5kb interval. 
Sym_score : Decimal ratio of the text in the Symmetry field.
libname : Short name of the genome library.

^^^^^^

TE Depletions Annotated (LibName_Depletion_Annotated_TEonly.txt): tab-delim table of TE depletions with genomic annotation information. Note: this file was extracted from the All Dels. Annotated file.

SV# : Structural variant number (sequential, ordered by genome coordinate order)
Chr _5p: Chromosome on the 5' end of the reads demarcating the depletion/deletion
Chr_coord_5p_start : genomic coordinate boundary start for the reads forming the 5' side of the cluster of TE depletion reads.
Chr_coord_5p_end : genomic coordinate boundary end for the reads forming the 5' side of the cluster of TE depletion reads.
Chr _3p: Chromosome on the 3' end of the reads demarcating the depletion/deletion
Chr_coord_3p_start: genomic coordinate boundary start for the reads forming the 3' side of the cluster of TE depletion reads.
Chr_coord_3p_end : genomic coordinate boundary end for the reads forming the 5' side of the cluster of TE depletion reads.
repName : name of TE family
Reads_collapsed : number of reads forming the read cluster demarcating the TE depletion/deletion (current minimum is 4 reads).
avg_del_len : number of bases between the Chr_coord_5p_end and the Chr_coord_3p_start values. Should be greater than 100bp (~1 length of Illumina read)
RefGen_3prime : number of reads mapping to the reference genome sequence within the 3'end window of the depletion.
RefGen_5prime : number of reads mapping to the reference genome sequence within the 5'end window of the depletion.
RefGen_Avg : average of RefGen_5prime and RefGen_3prime.
Coverage_Ratio : Calculation of TE depletion reads over reference genome reads plus a pseudocount. Depletion CR = ((TE reads) / (1+ RefGen_Avg)). The "1" is a pseudocount.
size: number of bases between the Chr_coord_5p_start and the Chr_coord_3p_end values.
Chr_5p : same as above.
Chr_coord_5p : same as Chr_coord_5p_start above.
classification_5p : Type of functional genomic annotation based on the genomic coordinate at Chr_5p (intron, exon, 3'UTR, 5'UTR, or intergenic).
comment_5p: Name of the RefSeq gene nearest to this genomic coordinates, along with the genomic strand orientation of the gene. 
Chr_mid : Chromosome at the midpoint of the depletion/deletion.
Chr_coord_mid : coordinate at the midpoint of the depletion/deletion.
classification_mid : Type of functional genomic annotation based on the genomic coordinate at the midpoint of the depletion/deletion (intron, exon, 3'UTR, 5'UTR, or intergenic).
comment_mid : Name of the RefSeq gene nearest to this genomic coordinate, along with the genomic strand orientation of the gene.
Chr_3p : same as above.
Chr_coord_3p : same as Chr_coord_3p_end above.
classification_3p : Type of functional genomic annotation based on the genomic coordinate at Chr_3p (intron, exon, 3'UTR, 5'UTR, or intergenic).
comment_3p: Name of the RefSeq gene nearest to this genomic coordinate, along with the genomic strand orientation of the gene.
depletion_code : A unique identifier string for SQL analyses. Combination of chromosome, reads_collapsed, and Chr_coord_mid coordinates rounded down to lowest 5kb interval.
loci_code : A unique identifier string for SQL analyses. Combination of chromosome, and Chr_coord_mid coordinates rounded down to lowest 5kb interval.
libname : Short name of the genome library.

^^^^^^

Fixed Bin Table (LibName_fixed_bin.txt) : tab-delim table of 5kb genomic intervals with counts of TE InDels.

Chrom : Chromosome number.
interval : genomic coordinate interval (5kb intervals).
span : span of the genomici coordinate.
Insert_Reads : number of reads comprising TE insertion.
Insert_Count : number of TE insertions.
Insert_Coverage_Ratio : the average CR of the TE insertions within the 5kb interval.
FREEC_ratio : the estimate copy number variation ratio predicted by the FREEC algorithm. Values of "-1" are too repetitive for FREEC to estimate a copy number variation ratio.
Depletion_Reads : number of reads comprising TE depletions.
Depletion_Count : number of TE depletions.
Depletion_Coverage_Ratio : the average CR of the TE depletions within the 5kb interval.
Insert_code : A unique identifier string for SQL analyses, pulled from Inserts_Annotated.
Depletion_code : A unique identifier string for SQL analyses, pulled from Depletion_Annotated_TEonly.
bin_code : A unique identifier string for SQL analyses. Combination of chromosome and coordinates rounded down to lowest 5kb interval.
libname : Short name of the genome library.
Mark_All : Sum of the Insert_Count (addition) and Depletion_Count (subtraction) for TE InDels at all CR values.
Mark_CR4 : Sum of the Insert_Count (addition) and Depletion_Count (subtraction) for only the TE InDels with a CR >=4.

^^^^^^

TE Ins. Reads (LibName_ ReadInsertion.txt) : tab delim table of the specific reads selected for calling each TE Insertion. Selecting the cluster of reads and using BLAT to query can reveal the specific insertion breakpoint.

Identifier : read sequence with read frequency.
strand : genomic strand polarity.
chr : chromosome.
coord : genomic coordinate.
5'/3' map gen : which end of the read maps to reference genome sequence.
strand : TE strand polarity. 
TE : TE family name.
coord : TE consensus sequence coordinate.
num_maps_concensus_TE : number of matched entries in the TE database.
Blat_score : The BLAT score for the read against the Release 6 / Dm6 genome sequence.

^^^^^^

All Del. Reads (LibName_ ReadDepletion.txt) : tab delim table of the specific reads selected for calling each Depletion. Selecting the cluster of reads and using BLAT to query can reveal the specific depletion breakpoint.

Identifier : read sequence with read frequency.
'5' seq : 5' end first 21nt sequence.
'3' seq : 3' end last 21nt sequence.
'5' strand : genomic strand polarity.
'5' chr : chromosome.
'5' coord : genomic coordinate.
'3' strand : genomic strand polarity.
'3' chr : chromosome.
'3' coord : genomic coordinate.
Del len : length of deletion/depletion.
'5' SPC : Strand Polarity Correction - if read maps to negative strand, flip read to positive strand so that all reads are consistent on strand for mapping the deletion/depletion consistently.
'5' corr chr : SPC corrected chromosome.
'5' corr coord : SPC corrected coordinate.
'3' SPC : Strand Polarity Correction - if read maps to negative strand, flip read to positive strand so that all reads are consistent on strand for mapping the deletion/depletion consistently.
'3' corr chr : SPC corrected chromosome.
'3' corr coord : SPC corrected coordinate.

^^^^^^
