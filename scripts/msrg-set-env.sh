#!/bin/bash

# Execute profile to make module command work
if [ !  -f "/usr/local/etc/distro" ]; then
  . /usr/local/lmod/7.8/init/profile
  echo "Moscquito Small RNA pipeline Container"

elif [ `/usr/local/etc/distro` == alma8 ]; then
  . /usr/local/lmod/8.7.12/init/profile
  echo "Mosquito Small RNA pipeline Alma8"

else
  . /usr/local/lmod/7.8/init/profile
  echo "Moscquito SMall RNA pipeline CentOS7"
  
fi



if [[ -d /.singularity.d ]]
then
  # If code runs from within the singularity container
  export msrg=/msrg  
else

  # If code runs normaly (no singularity container)
  export msrg=/projectnb/lau-bumc/katia/MosquitoSmallRNA/
fi


# Load appropriate module files
module load python3/3.8.10.clean
module load bedops/2.4.35
module load perl/5.34.0
module load bedtools/2.27.1
module load bowtie/1.0.0
module load samtools/1.10
module load blast/2.2.26
module load fastx-toolkit/0.0.14
module load R/4.1.1
module load bedtobigbed/2.6
module load ucscutils/2018-11-27


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
