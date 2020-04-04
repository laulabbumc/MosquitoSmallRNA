import sys
import argparse
import pysam

def main(args):
	my_sam_file = args.my_sam_file
	minimum_perfect_match = args.minimum_perfect_match	
	maximum_NM = args.maximum_NM	
	sam_output_file=args.sam_output_file
	samfile = pysam.AlignmentFile(my_sam_file, "r")
	filteredreads = pysam.AlignmentFile(sam_output_file, "w", template=samfile)
	for read in samfile:
		aligned_pairs = pysam.AlignedSegment.get_aligned_pairs(read,matches_only=True)
		if ( len(aligned_pairs) > 0 ):
			pos = pysam.AlignedSegment.get_reference_positions(read, full_length=False)
			NM = pysam.AlignedSegment.get_tag(read,'NM')
			if ( len(pos) - int(NM) >= int(minimum_perfect_match) and int(NM) <= int(maximum_NM) ):
				filteredreads.write(read)

	samfile.close()
	filteredreads.close()
			
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('my_sam_file')
	parser.add_argument('minimum_perfect_match')
	parser.add_argument('maximum_NM')
	parser.add_argument('sam_output_file')
	args=parser.parse_args()
	main(args)
