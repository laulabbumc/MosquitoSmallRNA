#!/bin/bash -l

module load python3/3.8.10.clean
module load bedops/2.4.35
module load perl/5.34.0
module load bedtools/2.27.1
module load bowtie/1.0.0
module load samtools/1.10
module load blast/2.2.26
module load fastx-toolkit/0.0.14
module load R/4.0.5
module load bedtobigbed/2.6
module load ucscutils/2018-11-27

export msrg=/MSRG/

# workdir should be the directory where sample file is located
export workdir=$(pwd)

# bindir is set to the directory where executable scripts are stored
export bindir=$msrg/bin/

# scrdir is set to the directory containing scripts to start various steps in the pipeline
export scrdir=$msrg/scripts/

# bindir should be added to the path
export PATH=$bindir:$PATH


echo "Working directory: $workdir"
echo "bin directory: $bindir"
echo "script directory: $scrdir"
