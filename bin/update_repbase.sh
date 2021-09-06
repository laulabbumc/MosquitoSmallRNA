#!/bin/sh


lt_create_idx $1\_$step
formatdb -i $1\_$step -p F -o T
bowtie-build $1\_$step $1\_$step

exit
