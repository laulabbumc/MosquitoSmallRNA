import sys
import argparse
import pandas as pd
def main(args):
	water_alignment=args.water_alignment
	with open(water_alignment, 'r') as file:
		target = file.readline().replace('\n', '')
		alignment = file.readline().replace('\n', '').replace('.',' ')
		query = file.readline().replace('\n', '')
		if (len(target) == len(query)):
			for i in range (len(target)):
				if (target[i]==query[i]) :
					alignment = alignment[:i] + '|'  + alignment[i + 1:]
				elif (target[i]=='T' and query[i]=='C' or target[i]=='G' and query[i]=='A' ) :
					alignment = alignment[:i] + '*'  + alignment[i + 1:]
				else :
					alignment = alignment[:i] + ' '  + alignment[i + 1:]
			print (target)
			print (alignment)
			print (query)
if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('water_alignment')
	args=parser.parse_args()
	main(args)
