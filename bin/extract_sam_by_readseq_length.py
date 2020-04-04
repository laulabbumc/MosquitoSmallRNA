import sys
import argparse
import pysam

def main(args):
	my_sam_file = args.my_sam_file
	minimum_readseq_length = args.minimum_readseq_length	
	maximum_readseq_length = args.maximum_readseq_length	
	sam_output_file=args.sam_output_file
	samfile = pysam.AlignmentFile(my_sam_file, "r")
	filteredreads = pysam.AlignmentFile(sam_output_file, "w", template=samfile)
	for read in samfile:	
#		read_seq = read.seq
#		read_qual = read.qual
#		print read_seq, len(read_seq)
		aligned_pairs = pysam.AlignedSegment.get_aligned_pairs(read)
#		print aligned_pairs
		if ( len(aligned_pairs) > 0 ):
			read_name = read.query_name.split(":")
#		print  read_name[0] , len(read_name[0]),  read
			if ( len(read_name[0]) >= int(minimum_readseq_length) and   len(read_name[0]) <= int(maximum_readseq_length) ):
			   	filteredreads.write(read)

	samfile.close()
	filteredreads.close()
			
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('my_sam_file')
	parser.add_argument('minimum_readseq_length')
	parser.add_argument('maximum_readseq_length')
	parser.add_argument('sam_output_file')
	args=parser.parse_args()
	main(args)
