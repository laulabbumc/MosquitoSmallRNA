#!/bin/sh
samfile=$1
bamfile=$2
samtools view -bhS $samfile  | samtools sort - -O BAM -o $bamfile
