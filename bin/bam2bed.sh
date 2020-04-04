#!/bin/bash
bedtools bamtobed  -i $1 | sort -k 4  > $2
