#!/bin/bash
i=`head -n 13 summary | grep 'total_read' | awk '{print $3}'` ; j=`head -n 13 summary | grep 'nogenome'  | awk '{print $3}'` ; expr $i - $j
