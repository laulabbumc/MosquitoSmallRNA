import sys
import argparse
import csv
import numpy as np

def main(args):
	my_bed_file = args.my_bed_file
	five_to_five_SPECIES_output_file = args.five_to_five_SPECIES_output_file
	plus5 =  dict ()
	minus5 =  dict ()
	with open(my_bed_file) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter='\t')
		for row in csv_reader:
#		print (row)
#			if ( (int(row[2]) - int(row[1])) > 23   ) :
			if ( (int(row[2]) - int(row[1])) < 36    ) :
				if ( row[5] == '+') :
					if ( row[0] in plus5 ):
						if ( int(row[1]) in plus5[row[0]] ):
							plus5[row[0]][int(row[1])] += float(row[3])/float(row[4])
						else:
							plus5[row[0]][int(row[1])] = float(row[3])/float(row[4])
					else:
						plus5[row[0]] = dict ()
						plus5[row[0]][int(row[1])] = float(row[3])/float(row[4])
				else:
					if ( row[0] in minus5 ):
						if ( int(row[2]) in minus5[row[0]] ):
							minus5[row[0]][int(row[2])] += float(row[3])/float(row[4])
						else:
							minus5[row[0]][int(row[2])] = float(row[3])/float(row[4])
					else:
						minus5[row[0]] = dict ()
						minus5[row[0]][int(row[2])] = float(row[3])/float(row[4])
	plot = 0
	plot2 = 0
	for  i in plus5 :	
		for  j in plus5[i] :
			for k in range ( 10, 11):
				if ( i in minus5  and (j+k) in minus5[i] ) :
					plot+= (plus5[i][j]+minus5[i][j+k]) / 2
					plot2 += 1
					print (i,j,j+k, plus5[i][j], minus5[i][j+k])
					plus5[i][j] =0
					minus5[i][j+k]=0
	for  i in minus5 :	
		for  j in minus5[i] :
			for k in range ( 10, 11):
				if ( i in plus5 and (j-k) in plus5[i] ) :
					plot+= (minus5[i][j]+plus5[i][j-k] ) /2
					plot2 += 1
					print (i,j-k,j, plus5[i][j-k], minus5[i][j] )
					minus5[i][j]=0
					plus5[i][j-k]=0
	with open(five_to_five_SPECIES_output_file, 'w' ) as csvfile:
		csv_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
		for k in range ( 10, 11):
			    csv_writer.writerow([k ,  float("{0:.4f}".format( plot )), plot2 ])						
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('my_bed_file')
	parser.add_argument('five_to_five_SPECIES_output_file')
	args=parser.parse_args()
	main(args)
