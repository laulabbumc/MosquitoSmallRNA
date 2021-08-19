#!/bin/bash
for i in `cat $1 ` ; do  awk -F'	' -v cond="$i" ' { if ($1==cond) print $0}' $2 ; done
