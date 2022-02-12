#!/bin/sh

IMAGE=/projectnb/lau-bumc/katia/MSRG/container/msrg.simg

singularity exec -e -B /scratch -B /projectnb/lau-bumc/katia:/work $IMAGE /msrg/scripts/step1_gene-centric.sh $1

