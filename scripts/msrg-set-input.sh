#!/bin/bash -l

# This script sets up input values

export organism=fly
export adapter=GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
export cutoff=20000000
export window=5

#input directory name (corresponding to a line in a sample file)
export i=$1

#location of the reference directory
export refdir=/projectnb/lau-bumc/katia/TEST/reference
