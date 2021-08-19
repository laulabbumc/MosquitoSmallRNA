import sys
import argparse
import pysam
import csv

def main(args):
	my_sam_file = args.my_sam_file
	minimum_readseq_length = args.minimum_readseq_length	
	maximum_readseq_length = args.maximum_readseq_length	
	read_length_distribution_file=args.read_length_distribution_file
	samfile = pysam.AlignmentFile(my_sam_file, "r")
	read_length_distribution = dict ()
	visited = dict ()
	for read in samfile.fetch():	
#		read_seq = read.seq
#		read_qual = read.qual
#		print read_seq, len(read_seq)
		aligned_pairs = pysam.AlignedSegment.get_aligned_pairs(read,matches_only=True)
#		print aligned_pairs
		if ( len(aligned_pairs) > 0 ):
			read_name = read.query_name.split(":")
			#print  (read_name[0] , len(read_name[0])) #,  read
			if ( len(read_name[0]) >= int(minimum_readseq_length) and   len(read_name[0]) <= int(maximum_readseq_length) and not ( read_name[0] in visited ) ):	
				visited [ read_name[0] ] = 1
				if ( len(read_name[0]) in read_length_distribution ):
						read_length_distribution [ len(read_name[0]) ] += int(read_name[1])
				else:
						read_length_distribution [ len(read_name[0]) ] = int(read_name[1])
	samfile.close()
	with open(read_length_distribution_file,'w') as csvfile:
		csv_writer = csv.writer(csvfile, delimiter='\t', quotechar='|', quoting=csv.QUOTE_MINIMAL)
		for k in read_length_distribution:
			 csv_writer.writerow([k,read_length_distribution[k]])
			
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('my_sam_file')
	parser.add_argument('minimum_readseq_length')
	parser.add_argument('maximum_readseq_length')
	parser.add_argument('read_length_distribution_file')
	args=parser.parse_args()
	main(args)
