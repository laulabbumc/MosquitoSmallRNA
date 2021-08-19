import sys
import argparse
import csv
import numpy as np

def main(args):
	all_length_file = args.all_length_file
	miRNA_length_file = args.miRNA_file
	TE_length_file = args.TE_file
	Virus_length_file = args.Virus_file
	structureRNA_length_file = args.structureRNA_file
	combined_file = args.combined_file
	all_length =  dict ()
	with open(all_length_file) as all_length_csv_file:
		csv_reader = csv.reader(all_length_csv_file, delimiter='\t')
		for row in csv_reader:
#		print (row)
			all_length [ int(row[0]) ] = int(row [1])
	miRNA_length =  dict ()
	with open(miRNA_length_file) as miRNA_length_csv_file:
		csv_reader = csv.reader(miRNA_length_csv_file, delimiter='\t')
		for row in csv_reader:
#		print (row)
			miRNA_length [ int(row[0]) ] = int(row [1])
	TE_length =  dict ()
	with open(TE_length_file) as TE_length_csv_file:
		csv_reader = csv.reader(TE_length_csv_file, delimiter='\t')
		for row in csv_reader:
#		print (row)
			TE_length [ int(row[0]) ] = int(row [1])
	Virus_length =  dict ()
	with open(Virus_length_file) as Virus_length_csv_file:
		csv_reader = csv.reader(Virus_length_csv_file, delimiter='\t')
		for row in csv_reader:
#		print (row)
			Virus_length [ int(row[0]) ] = int(row [1])
	structureRNA_length =  dict ()
	with open(structureRNA_length_file) as structureRNA_length_csv_file:
		csv_reader = csv.reader(structureRNA_length_csv_file, delimiter='\t')
		for row in csv_reader:
#		print (row)
			structureRNA_length [ int(row[0]) ] = int(row [1])
		
	with open(combined_file, 'w' ) as csvfile:
		csv_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
		csv_writer.writerow(["Length" ,  "TotalCount", "miRNACount", "TECount", "VirusCount", "StructureRNACount"])						
		for k in sorted(all_length):
			if ( k in miRNA_length ):
				miRNA_count=miRNA_length[k]
			else:
				miRNA_count=0			
			if ( k in TE_length ):
				TE_count=TE_length[k]
			else:
				TE_count=0			
			if ( k in Virus_length ):
				Virus_count=Virus_length[k]
			else:
				Virus_count=0			
			if ( k in structureRNA_length ):
				structureRNA_count=structureRNA_length[k]
			else:
				structureRNA_count=0			
			csv_writer.writerow([k , all_length[k], miRNA_count, TE_count, Virus_count, structureRNA_count ])						
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('all_length_file')
	parser.add_argument('miRNA_file')
	parser.add_argument('TE_file')
	parser.add_argument('Virus_file')
	parser.add_argument('structureRNA_file')
	parser.add_argument('combined_file')
	args=parser.parse_args()
	main(args)
