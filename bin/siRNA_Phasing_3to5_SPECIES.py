import sys
import argparse
import csv
import numpy as np

def main(args):
	my_bed_file = args.my_bed_file
	three_to_five_SPECIES_output_file = args.three_to_five_SPECIES_output_file
	plus5 =  dict ()
	plus3 =  dict ()
	minus5 =  dict ()
	minus3 =  dict ()
	with open(my_bed_file) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter='\t')
		for row in csv_reader:
#		print (row)
			if ( (int(row[2]) - int(row[1]))  > 17 and (int(row[2]) - int(row[1])) < 24  ):
				if ( row[5] == '+') :
					if ( row[0] in plus5 ):
						if ( int(row[1]) in plus5[row[0]] ):
							plus5[row[0]][int(row[1])] += 1.0/float(row[4])
						else:
							plus5[row[0]][int(row[1])] = 1.0/float(row[4])
					else:
						plus5[row[0]] = dict ()
						plus5[row[0]][int(row[1])] = 1.0/float(row[4])
					if ( row[0] in plus3 ):
						if ( int(row[2]) in plus3[row[0]] ):
							plus3[row[0]][int(row[2])] += 1.0/float(row[4])
						else:
							plus3[row[0]][int(row[2])] = 1.0/float(row[4])
					else:
						plus3[row[0]] = dict ()
						plus3[row[0]][int(row[2])] = 1.0/float(row[4])
				else:
					if ( row[0] in minus5 ):
						if ( int(row[2]) in minus5[row[0]] ):
							minus5[row[0]][int(row[2])] += 1.0/float(row[4])
						else:
							minus5[row[0]][int(row[2])] = 1.0/float(row[4])
					else:
						minus5[row[0]] = dict ()
						minus5[row[0]][int(row[2])] = 1.0/float(row[4])
					if ( row[0] in minus3 ):
						if ( int(row[1]) in minus3[row[0]] ):
							minus3[row[0]][int(row[1])] += 1.0/float(row[4])
						else:
							minus3[row[0]][int(row[1])] = 1.0/float(row[4])
					else:
						minus3[row[0]] = dict ()
						minus3[row[0]][int(row[1])] = 1.0/float(row[4])
	plot = np.zeros(401,dtype=float)			
	for  i in plus3 :	
		for  j in plus3[i] :
			for k in range ( -200, 201):
				if ( (j+k) in plus5[i] ) :
					plot[k]+=plus3[i][j]*plus5[i][j+k]
	for  i in minus3 :	
		for  j in minus3[i] :
			for k in range ( -200, 201):
				if ( (j-k) in minus5[i] ) :
					plot[k]+=minus3[i][j]*minus5[i][j-k]
	with open(three_to_five_SPECIES_output_file, 'w' ) as csvfile:
		csv_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
		csv_writer.writerow([-200 ,  float("{0:.4f}".format( plot[-200]/2.0 ))])						
		for k in range ( -199, 200):
			    csv_writer.writerow([k ,  float("{0:.4f}".format( plot[k] ))])						
		csv_writer.writerow([200 ,  float("{0:.4f}".format( plot[200]/2.0 ))])						
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('my_bed_file')
	parser.add_argument('three_to_five_SPECIES_output_file')
	args=parser.parse_args()
	main(args)
